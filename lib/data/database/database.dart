import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/exercise_dao.dart';
import 'daos/session_dao.dart';
import 'daos/template_dao.dart';
import 'history_data.dart';
import 'seed_data.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Exercises,
    ExerciseMuscles,
    WorkoutTemplates,
    TemplateExercises,
    WorkoutSessions,
    SessionExercises,
    SetEntries,
    ActiveSessionDrafts,
    AppSettings,
  ],
  daos: [ExerciseDao, TemplateDao, SessionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : seedHistory = true,
        super(driftDatabase(name: 'gym_tracker'));

  AppDatabase.forTesting(super.executor, {this.seedHistory = false});

  /// Import de l'historique transcrit au premier remplissage d'une base
  /// neuve (`onCreate`). Désactivé dans les tests pour partir d'une base
  /// vierge ; la migration v4, elle, importe toujours.
  final bool seedHistory;

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await _migrateToV2(m);
          }
          if (from < 3) {
            await _migrateToV3(m);
          }
          if (from < 4) {
            await _migrateToV4(m);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ----- Réglages clé → valeur -----

  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) {
    return into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(key: Value(key), value: Value(value)),
    );
  }

  /// v3 → v4 : réglages applicatifs (thème…), note par exercice de séance,
  /// distance pour le cardio, catalogue enrichi (machines de la salle,
  /// street workout, cardio), templates des séances types et import de
  /// l'historique d'entraînement transcrit. Idempotent.
  Future<void> _migrateToV4(Migrator m) async {
    await m.createTable(appSettings);
    if (!await _columnExists('session_exercises', 'notes')) {
      await m.addColumn(sessionExercises, sessionExercises.notes);
    }
    if (!await _columnExists('set_entries', 'distance_meters')) {
      await m.addColumn(setEntries, setEntries.distanceMeters);
    }

    // Nouveaux exercices du catalogue (par nom, sans doublon).
    final existingNames = (await customSelect('SELECT name FROM exercises')
            .get())
        .map((r) => r.read<String>('name'))
        .toSet();
    for (final seed in kSeedExercisesV4) {
      if (!existingNames.contains(seed.name)) {
        await _insertSeedExercise(seed);
      }
    }

    // Templates des séances types (par nom, sans doublon).
    final existingTemplates =
        (await customSelect('SELECT name FROM workout_templates').get())
            .map((r) => r.read<String>('name'))
            .toSet();
    for (final template in kSeedTemplatesV4) {
      if (!existingTemplates.contains(template.name)) {
        await _insertSeedTemplate(template);
      }
    }

    await _importHistoryOnce();
  }

  /// Importe l'historique transcrit des notes (une séance par date), une
  /// seule fois — protégé par un drapeau dans les réglages.
  Future<void> _importHistoryOnce() async {
    if (await getSetting('history_imported') != null) return;

    final idRows =
        await customSelect('SELECT id, name FROM exercises').get();
    final idsByName = {
      for (final row in idRows) row.read<String>('name'): row.read<int>('id'),
    };

    // Regroupe les entrées par date en préservant l'ordre des notes.
    final byDay = <String, List<HistoryEntry>>{};
    for (final entry in kHistoryEntries) {
      byDay.putIfAbsent(entry.day, () => []).add(entry);
    }

    await transaction(() async {
      for (final dayEntries in byDay.values) {
        final parts = dayEntries.first.day.split('/');
        final date = DateTime(
            kHistoryYear, int.parse(parts[1]), int.parse(parts[0]), 18);
        final pages = <String>{for (final e in dayEntries) e.page};
        final sessionId = await into(workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: date,
            name: pages.join(' + '),
            notes: const Value('Importé des notes'),
          ),
        );
        for (var i = 0; i < dayEntries.length; i++) {
          final entry = dayEntries[i];
          final exerciseId = idsByName[entry.exercise];
          if (exerciseId == null) continue;
          final sessionExerciseId = await into(sessionExercises).insert(
            SessionExercisesCompanion.insert(
              sessionId: sessionId,
              exerciseId: exerciseId,
              position: i,
              notes: Value(entry.note),
            ),
          );
          final sets = parseHistorySets(entry.sets);
          for (var s = 0; s < sets.length; s++) {
            await into(setEntries).insert(SetEntriesCompanion.insert(
              sessionExerciseId: sessionExerciseId,
              setNumber: s + 1,
              weightKg: sets[s].weightKg,
              reps: sets[s].reps,
            ));
          }
        }
      }
      await setSetting('history_imported', '1');
    });
  }

  /// v2 → v3 : type d'exercice (poids × reps ou durée), durée par série,
  /// et table de sauvegarde de la séance en cours. Idempotent.
  Future<void> _migrateToV3(Migrator m) async {
    await m.createTable(activeSessionDrafts);
    if (!await _columnExists('exercises', 'exercise_type')) {
      await m.addColumn(exercises, exercises.exerciseType);
    }
    if (!await _columnExists('set_entries', 'duration_seconds')) {
      await m.addColumn(setEntries, setEntries.durationSeconds);
    }
    // Aligne les exercices du catalogue mesurés en secondes.
    for (final seed in kSeedExercises.where((e) => e.isDuration)) {
      await (update(exercises)..where((e) => e.name.equals(seed.name))).write(
        const ExercisesCompanion(exerciseType: Value(ExerciseTypes.duration)),
      );
    }
  }

  Future<bool> _columnExists(String table, String column) async {
    final rows = await customSelect(
      "SELECT 1 AS present FROM pragma_table_info('$table') WHERE name = ?",
      variables: [Variable.withString(column)],
    ).get();
    return rows.isNotEmpty;
  }

  /// v1 → v2 : les exercices passent d'un groupe musculaire unique (colonne
  /// texte) à plusieurs groupes (table d'association). Les exercices et
  /// l'historique existants sont conservés, le catalogue est enrichi.
  ///
  /// Les migrations SQLite ne sont pas transactionnelles de bout en bout :
  /// chaque étape vérifie l'état réel de la base pour pouvoir reprendre
  /// proprement après une interruption.
  Future<void> _migrateToV2(Migrator m) async {
    // CREATE TABLE IF NOT EXISTS : sans effet si la table existe déjà.
    await m.createTable(exerciseMuscles);

    if (!await _columnExists('exercises', 'is_custom')) {
      await m.addColumn(exercises, exercises.isCustom);
    }
    // alterTable ci-dessous recrée la table selon le schéma COURANT (v3+) :
    // toutes ses colonnes doivent exister avant la copie, y compris celles
    // introduites par les migrations suivantes.
    if (!await _columnExists('exercises', 'exercise_type')) {
      await m.addColumn(exercises, exercises.exerciseType);
    }

    final catalogByName = {for (final e in kSeedExercises) e.name: e};
    final existingNames = <String>{};

    if (await _columnExists('exercises', 'muscle_group')) {
      // Lire les anciens groupes AVANT de supprimer la colonne.
      final oldRows =
          await customSelect('SELECT id, name, muscle_group FROM exercises')
              .get();
      for (final row in oldRows) {
        final id = row.read<int>('id');
        final name = row.read<String>('name');
        final legacyLabel = row.read<String>('muscle_group');
        existingNames.add(name);
        final slugs = catalogByName[name]?.muscles ??
            [kLegacyLabelToSlug[legacyLabel] ?? legacyLabel.toLowerCase()];
        for (final slug in slugs) {
          await into(exerciseMuscles).insert(
            ExerciseMusclesCompanion.insert(exerciseId: id, muscleGroup: slug),
            mode: InsertMode.insertOrIgnore,
          );
        }
      }
      // Supprime la colonne muscle_group (recrée la table selon le schéma
      // v2). Doit précéder les insertions ci-dessous : tant que la colonne
      // existe, sa contrainte NOT NULL rejetterait les nouveaux exercices.
      await m.alterTable(TableMigration(exercises));
    } else {
      // Colonne déjà supprimée par une migration interrompue.
      final rows = await customSelect('SELECT name FROM exercises').get();
      existingNames.addAll(rows.map((r) => r.read<String>('name')));
    }

    // Nouveaux exercices du catalogue étendu.
    for (final seed in kSeedExercises) {
      if (!existingNames.contains(seed.name)) {
        await _insertSeedExercise(seed);
      }
    }
  }

  Future<int> _insertSeedExercise(SeedExercise seed) async {
    final id = await into(exercises).insert(ExercisesCompanion.insert(
      name: seed.name,
      equipment: seed.equipment,
      description: Value(seed.description),
      defaultRestSeconds: Value(seed.restSeconds),
      exerciseType: Value(seed.isCardio
          ? ExerciseTypes.cardio
          : seed.isDuration
              ? ExerciseTypes.duration
              : ExerciseTypes.reps),
    ));
    for (final slug in seed.muscles) {
      await into(exerciseMuscles).insert(
        ExerciseMusclesCompanion.insert(exerciseId: id, muscleGroup: slug),
      );
    }
    return id;
  }

  /// Pré-remplit une base neuve : catalogue complet, templates par défaut
  /// et séances types, historique d'entraînement transcrit.
  Future<void> _seedAll() async {
    for (final seed in [...kSeedExercises, ...kSeedExercisesV4]) {
      await _insertSeedExercise(seed);
    }
    for (final template in [...kSeedTemplates, ...kSeedTemplatesV4]) {
      await _insertSeedTemplate(template);
    }
    if (seedHistory) {
      await _importHistoryOnce();
    }
  }

  Future<void> _insertSeedTemplate(SeedTemplate template) async {
    final idRows = await customSelect('SELECT id, name FROM exercises').get();
    final idsByName = {
      for (final row in idRows) row.read<String>('name'): row.read<int>('id'),
    };
    final templateId = await into(workoutTemplates).insert(
      WorkoutTemplatesCompanion.insert(
        name: template.name,
        description: Value(template.description),
        tags: Value(template.tags),
      ),
    );
    for (var i = 0; i < template.items.length; i++) {
      final (exerciseName, sets, reps, rest) = template.items[i];
      await into(templateExercises).insert(TemplateExercisesCompanion.insert(
        templateId: templateId,
        exerciseId: idsByName[exerciseName]!,
        position: i,
        targetSets: sets,
        targetReps: reps,
        restSeconds: rest,
      ));
    }
  }
}
