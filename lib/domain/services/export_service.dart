import '../../data/database/database.dart';
import '../../data/export/data_export.dart';

class ExportService {
  final AppDatabase database;

  ExportService({required this.database});

  Future<DataExport> createExport() async {
    final now = DateTime.now();

    // Exporter les exercices
    final allExercises = await database.exerciseDao.getAllExercises();
    final exercises = <Map<String, dynamic>>[];
    for (final e in allExercises) {
      final muscleSlugs = await database.exerciseDao.getMusclesForExercise(e.id);
      exercises.add({
        'id': e.id,
        'name': e.name,
        'equipment': e.equipment,
        'description': e.description,
        'muscleSlugs': muscleSlugs,
        'isCustom': e.isCustom,
        'exerciseType': e.exerciseType,
        'defaultRestSeconds': e.defaultRestSeconds,
      });
    }

    // Exporter les templates
    final allTemplates = await database.templateDao.getAllWithExercises();
    final templates = [
      for (final t in allTemplates)
        {
          'id': t.template.id,
          'name': t.template.name,
          'description': t.template.description,
          'tags': t.template.tags,
          'exercises': [
            for (final link in t.exercises)
              {
                'exerciseId': link.exercise.exercise.id,
                'exerciseName': link.exercise.exercise.name,
                'targetSets': link.link.targetSets,
                'targetReps': link.link.targetReps,
                'restSeconds': link.link.restSeconds,
              }
          ],
        }
    ];

    // Exporter les séances
    final allSessions = await database.sessionDao.getAllWithExercises();
    final sessions = [
      for (final s in allSessions)
        {
          'id': s.session.id,
          'name': s.session.name,
          'date': s.session.date.toIso8601String(),
          'exercises': [
            for (final ex in s.exercises)
              {
                'exerciseId': ex.exercise.id,
                'exerciseName': ex.exercise.name,
                'notes': ex.notes,
                'sets': [
                  for (final set in ex.sets)
                    {
                      'weight': set.weightKg,
                      'reps': set.reps,
                      if ((set.durationSeconds ?? 0) > 0) 'durationSeconds': set.durationSeconds,
                      if ((set.distanceMeters ?? 0) > 0) 'distanceMeters': set.distanceMeters,
                    }
                ]
              }
          ],
        }
    ];

    return DataExport(
      exportDate: now.toIso8601String(),
      schemaVersion: 4,
      exercises: exercises,
      templates: templates,
      sessions: sessions,
    );
  }
}
