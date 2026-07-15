import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/tables.dart';

/// Contenu d'un export JSON : maps sérialisables telles quelles, produites
/// par ExportService et relues par DataImporter.
class DataExport {
  final List<Map<String, dynamic>> exercises;
  final List<Map<String, dynamic>> templates;
  final List<Map<String, dynamic>> sessions;
  final String exportDate;
  final int schemaVersion;

  DataExport({
    required this.exercises,
    required this.templates,
    required this.sessions,
    required this.exportDate,
    required this.schemaVersion,
  });

  Map<String, dynamic> toJson() => {
        'exportDate': exportDate,
        'schemaVersion': schemaVersion,
        'exercises': exercises,
        'templates': templates,
        'sessions': sessions,
      };

  factory DataExport.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> readList(String key) => [
          for (final item in (json[key] as List? ?? const []))
            (item as Map).cast<String, dynamic>(),
        ];
    return DataExport(
      exportDate: json['exportDate'] as String? ?? '',
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 4,
      exercises: readList('exercises'),
      templates: readList('templates'),
      sessions: readList('sessions'),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static DataExport? fromJsonString(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DataExport.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

/// Bilan d'un import, affiché à l'utilisateur.
class ImportResult {
  const ImportResult({
    required this.importedSessions,
    required this.skippedSessions,
    required this.importedTemplates,
    required this.createdExercises,
  });

  final int importedSessions;
  final int skippedSessions;
  final int importedTemplates;
  final int createdExercises;
}

/// Importe un export JSON en base, dans une transaction.
///
/// Les ids d'exercices de l'export ne sont JAMAIS réutilisés tels quels :
/// chaque exercice est réconcilié par nom avec le catalogue local, et créé
/// s'il n'existe pas. Ré-importer le même fichier est sans effet (séances
/// dédoublonnées par nom + date, templates par nom).
class DataImporter {
  static Future<ImportResult> importData(
    AppDatabase database,
    DataExport export,
  ) {
    return database.transaction(() async {
      // 1. Réconciliation des exercices par nom → table de correspondance
      //    id exporté → id local.
      final local = await database.exerciseDao.getAllExercises();
      final idByName = {
        for (final e in local) e.name.trim().toLowerCase(): e.id,
      };
      final idMap = <int, int>{};
      var createdExercises = 0;
      for (final exJson in export.exercises) {
        final exportedId = (exJson['id'] as num?)?.toInt();
        final name = ((exJson['name'] as String?) ?? '').trim();
        if (exportedId == null || name.isEmpty) continue;
        final existingId = idByName[name.toLowerCase()];
        if (existingId != null) {
          idMap[exportedId] = existingId;
          continue;
        }
        final newId = await database.exerciseDao.createExercise(
          name: name,
          equipment: (exJson['equipment'] as String?) ?? '',
          description: (exJson['description'] as String?) ?? '',
          defaultRestSeconds:
              (exJson['defaultRestSeconds'] as num?)?.toInt() ?? 120,
          muscleSlugs:
              (exJson['muscleSlugs'] as List?)?.cast<String>() ?? const [],
          exerciseType:
              (exJson['exerciseType'] as String?) ?? ExerciseTypes.reps,
        );
        idByName[name.toLowerCase()] = newId;
        idMap[exportedId] = newId;
        createdExercises++;
      }

      // 2. Templates, dédoublonnés par nom.
      final existingTemplates =
          await database.select(database.workoutTemplates).get();
      final templateNames = {
        for (final t in existingTemplates) t.name.trim().toLowerCase(),
      };
      var importedTemplates = 0;
      for (final tJson in export.templates) {
        final name = ((tJson['name'] as String?) ?? '').trim();
        if (name.isEmpty || templateNames.contains(name.toLowerCase())) {
          continue;
        }
        final templateId =
            await database.into(database.workoutTemplates).insert(
                  WorkoutTemplatesCompanion.insert(
                    name: name,
                    description:
                        Value((tJson['description'] as String?) ?? ''),
                    tags: Value((tJson['tags'] as String?) ?? ''),
                  ),
                );
        final items =
            (tJson['exercises'] as List? ?? const []).cast<Map>();
        var position = 0;
        for (final item in items) {
          final exJson = item.cast<String, dynamic>();
          final exerciseId = idMap[(exJson['exerciseId'] as num?)?.toInt()];
          if (exerciseId == null) continue;
          await database.into(database.templateExercises).insert(
                TemplateExercisesCompanion.insert(
                  templateId: templateId,
                  exerciseId: exerciseId,
                  position: position++,
                  targetSets: (exJson['targetSets'] as num?)?.toInt() ?? 3,
                  targetReps: (exJson['targetReps'] as num?)?.toInt() ?? 10,
                  restSeconds:
                      (exJson['restSeconds'] as num?)?.toInt() ?? 120,
                ),
              );
        }
        templateNames.add(name.toLowerCase());
        importedTemplates++;
      }

      // 3. Séances, dédoublonnées par (nom, date).
      final existingSessions =
          await database.select(database.workoutSessions).get();
      final sessionKeys = {
        for (final s in existingSessions)
          '${s.name.trim().toLowerCase()}|${s.date.toIso8601String()}',
      };
      var importedSessions = 0, skippedSessions = 0;
      for (final sJson in export.sessions) {
        final name = ((sJson['name'] as String?) ?? '').trim();
        final date = DateTime.tryParse((sJson['date'] as String?) ?? '');
        if (date == null) {
          skippedSessions++;
          continue;
        }
        final key = '${name.toLowerCase()}|${date.toIso8601String()}';
        if (sessionKeys.contains(key)) {
          skippedSessions++;
          continue;
        }
        sessionKeys.add(key);
        final sessionId = await database.into(database.workoutSessions).insert(
              WorkoutSessionsCompanion.insert(name: name, date: date),
            );

        final sexercises =
            (sJson['exercises'] as List? ?? const []).cast<Map>();
        var position = 0;
        for (final item in sexercises) {
          final exJson = item.cast<String, dynamic>();
          final exerciseId = idMap[(exJson['exerciseId'] as num?)?.toInt()];
          if (exerciseId == null) continue;
          final seId = await database.into(database.sessionExercises).insert(
                SessionExercisesCompanion.insert(
                  sessionId: sessionId,
                  exerciseId: exerciseId,
                  position: position++,
                  notes: Value((exJson['notes'] as String?) ?? ''),
                ),
              );

          final sets = (exJson['sets'] as List? ?? const []).cast<Map>();
          for (var s = 0; s < sets.length; s++) {
            final setJson = sets[s].cast<String, dynamic>();
            await database.into(database.setEntries).insert(
                  SetEntriesCompanion.insert(
                    sessionExerciseId: seId,
                    setNumber: s + 1,
                    weightKg: (setJson['weight'] as num?)?.toDouble() ?? 0,
                    reps: (setJson['reps'] as num?)?.toInt() ?? 0,
                    durationSeconds:
                        Value((setJson['durationSeconds'] as num?)?.toInt()),
                    distanceMeters: Value(
                        (setJson['distanceMeters'] as num?)?.toDouble()),
                  ),
                );
          }
        }
        importedSessions++;
      }

      return ImportResult(
        importedSessions: importedSessions,
        skippedSessions: skippedSessions,
        importedTemplates: importedTemplates,
        createdExercises: createdExercises,
      );
    });
  }
}
