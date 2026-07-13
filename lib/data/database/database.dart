import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/exercise_dao.dart';
import 'daos/session_dao.dart';
import 'daos/template_dao.dart';
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
  ],
  daos: [ExerciseDao, TemplateDao, SessionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'gym_tracker'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

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
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

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
      exerciseType: Value(
          seed.isDuration ? ExerciseTypes.duration : ExerciseTypes.reps),
    ));
    for (final slug in seed.muscles) {
      await into(exerciseMuscles).insert(
        ExerciseMusclesCompanion.insert(exerciseId: id, muscleGroup: slug),
      );
    }
    return id;
  }

  /// Pré-remplit une base neuve : catalogue complet + templates par défaut.
  Future<void> _seedAll() async {
    final idsByName = <String, int>{};
    for (final seed in kSeedExercises) {
      idsByName[seed.name] = await _insertSeedExercise(seed);
    }

    for (final template in kSeedTemplates) {
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
}
