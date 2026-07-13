import '../../data/database/database.dart';
import '../../data/database/tables.dart';
import 'muscle_groups.dart';

/// Un exercice avec ses groupes musculaires.
class ExerciseDetail {
  const ExerciseDetail({required this.exercise, required this.muscleSlugs});

  final Exercise exercise;

  /// Slugs des groupes travaillés, dans l'ordre du catalogue.
  final List<String> muscleSlugs;

  String get muscleLabel =>
      muscleSlugs.map((s) => muscleGroupBySlug(s).label).join(' · ');

  bool worksGroup(String slug) => muscleSlugs.contains(slug);

  /// Vrai si l'exercice est mesuré en secondes (planche…).
  bool get isDuration => exercise.exerciseType == ExerciseTypes.duration;

  /// Vrai pour les exercices cardio (durée + distance).
  bool get isCardio => exercise.exerciseType == ExerciseTypes.cardio;
}
