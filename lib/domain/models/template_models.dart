import '../../data/database/database.dart';
import 'exercise_models.dart';

/// Un exercice d'un template avec ses paramètres (séries, reps, repos).
class TemplateExerciseDetail {
  const TemplateExerciseDetail({required this.link, required this.exercise});

  final TemplateExercise link;
  final ExerciseDetail exercise;
}

/// Un template complet avec ses exercices ordonnés.
class TemplateWithExercises {
  const TemplateWithExercises({required this.template, required this.exercises});

  final WorkoutTemplate template;
  final List<TemplateExerciseDetail> exercises;

  List<String> get tags => template.tags
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();
}

/// Élément d'un template en cours d'édition (avant sauvegarde).
class TemplateExerciseDraft {
  const TemplateExerciseDraft({
    required this.exerciseId,
    required this.targetSets,
    required this.targetReps,
    required this.restSeconds,
  });

  final int exerciseId;
  final int targetSets;
  final int targetReps;
  final int restSeconds;
}
