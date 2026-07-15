import '../models/exercise_models.dart';

/// Exercices de remplacement classés par pertinence : groupes musculaires
/// partagés d'abord, puis même type (poids×reps / durée / cardio), puis
/// même équipement (machine occupée → autre machine ou poids libres).
List<ExerciseDetail> suggestReplacements({
  required ExerciseDetail target,
  required List<ExerciseDetail> all,
  Set<int> excludeIds = const {},
  int limit = 8,
}) {
  final targetMuscles = target.muscleSlugs.toSet();
  final scored = <(int, ExerciseDetail)>[];
  for (final candidate in all) {
    final id = candidate.exercise.id;
    if (id == target.exercise.id || excludeIds.contains(id)) continue;
    final shared = targetMuscles.intersection(candidate.muscleSlugs.toSet());
    if (shared.isEmpty) continue;
    var score = shared.length * 10;
    if (candidate.exercise.exerciseType == target.exercise.exerciseType) {
      score += 5;
    }
    if (candidate.exercise.equipment == target.exercise.equipment) score += 1;
    scored.add((score, candidate));
  }
  scored.sort((a, b) => b.$1.compareTo(a.$1));
  return [for (final (_, detail) in scored.take(limit)) detail];
}
