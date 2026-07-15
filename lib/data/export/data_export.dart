import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';

/// Sérialisation/désérialisation simplifiée pour export/import JSON.
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
    return DataExport(
      exportDate: json['exportDate'] as String? ?? '',
      schemaVersion: json['schemaVersion'] as int? ?? 4,
      exercises: (json['exercises'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      templates: (json['templates'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      sessions: (json['sessions'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          [],
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

/// Importe les données depuis un JSON.
class DataImporter {
  static Future<void> importData(
    AppDatabase database,
    DataExport export,
  ) async {
    // Importer les exercices personnalisés
    for (final exJson in export.exercises) {
      if (exJson['isCustom'] == true) {
        final muscleSlugs = (exJson['muscleSlugs'] as List?)?.cast<String>() ?? [];
        await database.exerciseDao.createExercise(
          name: (exJson['name'] as String?) ?? '',
          equipment: (exJson['equipment'] as String?) ?? '',
          description: (exJson['description'] as String?) ?? '',
          defaultRestSeconds: (exJson['defaultRestSeconds'] as int?) ?? 120,
          muscleSlugs: muscleSlugs,
          exerciseType: (exJson['exerciseType'] as String?) ?? 'reps',
        );
      }
    }

    // Importer les templates
    for (final tJson in export.templates) {
      final templateId = await database.into(database.workoutTemplates).insert(
            WorkoutTemplatesCompanion.insert(
              name: (tJson['name'] as String?) ?? '',
              description: Value((tJson['description'] as String?) ?? ''),
              tags: Value((tJson['tags'] as String?) ?? ''),
            ),
          );

      final texercises = (tJson['exercises'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var i = 0; i < texercises.length; i++) {
        final exJson = texercises[i];
        await database.into(database.templateExercises).insert(
              TemplateExercisesCompanion.insert(
                templateId: templateId,
                exerciseId: exJson['exerciseId'] as int? ?? 0,
                position: i,
                targetSets: exJson['targetSets'] as int? ?? 3,
                targetReps: exJson['targetReps'] as int? ?? 10,
                restSeconds: exJson['restSeconds'] as int? ?? 120,
              ),
            );
      }
    }

    // Importer les séances
    for (final sJson in export.sessions) {
      final sessionId = await database.into(database.workoutSessions).insert(
            WorkoutSessionsCompanion.insert(
              name: sJson['name'] as String? ?? '',
              date: DateTime.parse(sJson['date'] as String? ?? DateTime.now().toIso8601String()),
            ),
          );

      final sexercises = (sJson['exercises'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (final exJson in sexercises) {
        final seId = await database.into(database.sessionExercises).insert(
              SessionExercisesCompanion.insert(
                sessionId: sessionId,
                exerciseId: (exJson['exerciseId'] as int?) ?? 0,
                notes: Value((exJson['notes'] as String?) ?? ''),
                position: 0,
              ),
            );

        final sets = (exJson['sets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var s = 0; s < sets.length; s++) {
          final setJson = sets[s];
          final distance = setJson['distanceMeters'] as int?;
          await database.into(database.setEntries).insert(
                SetEntriesCompanion.insert(
                  sessionExerciseId: seId,
                  setNumber: s + 1,
                  weightKg: (setJson['weight'] as int? ?? 0).toDouble(),
                  reps: (setJson['reps'] as int?) ?? 0,
                  durationSeconds: Value(setJson['durationSeconds'] as int?),
                  distanceMeters: Value(distance?.toDouble()),
                ),
              );
        }
      }
    }

    // Marquer l'import comme réalisé
    await database.setSetting('data_imported', 'true');
  }
}
