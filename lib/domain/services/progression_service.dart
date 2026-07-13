import 'dart:math';

import '../../data/database/database.dart';
import '../models/progress_models.dart';

/// Logique métier de progression : suggestions de charge, volume, 1RM.
class ProgressionService {
  /// Incrément de charge proposé quand l'objectif est atteint.
  static const double weightIncrement = 2.5;

  /// Suggère poids et répétitions pour la prochaine séance.
  ///
  /// Règle : si l'objectif de répétitions a été atteint sur TOUTES les
  /// séries la dernière fois, suggérer +2,5 kg ; sinon reprendre les
  /// mêmes poids/répétitions.
  PerformanceSuggestion? suggest({
    required List<SetEntry> lastSets,
    required int targetReps,
  }) {
    if (lastSets.isEmpty) return null;
    final maxWeight = lastSets.map((s) => s.weightKg).reduce(max);
    final allTargetsReached = lastSets.every((s) => s.reps >= targetReps);
    if (allTargetsReached) {
      return PerformanceSuggestion(
        weightKg: maxWeight + weightIncrement,
        reps: targetReps,
        increased: true,
      );
    }
    return PerformanceSuggestion(
      weightKg: maxWeight,
      reps: targetReps,
      increased: false,
    );
  }

  /// Incrément proposé pour les exercices en durée.
  static const int durationIncrementSeconds = 15;

  /// Variante pour les exercices mesurés en secondes : +15 s si la durée
  /// cible a été tenue sur toutes les séries, sinon même durée.
  PerformanceSuggestion? suggestDuration({
    required List<SetEntry> lastSets,
    required int targetSeconds,
  }) {
    final durations = [
      for (final set in lastSets)
        if (set.durationSeconds != null) set.durationSeconds!,
    ];
    if (durations.isEmpty) return null;
    final maxDuration = durations.reduce(max);
    final allTargetsReached = durations.every((d) => d >= targetSeconds);
    return PerformanceSuggestion(
      weightKg: 0,
      reps: 0,
      increased: allTargetsReached,
      isDuration: true,
      durationSeconds: allTargetsReached
          ? maxDuration + durationIncrementSeconds
          : maxDuration,
    );
  }

  /// 1RM estimé par la formule d'Epley : poids × (1 + reps / 30).
  double estimateOneRm(double weightKg, int reps) {
    if (reps <= 0) return weightKg;
    return weightKg * (1 + reps / 30);
  }

  /// Volume total : somme des poids × répétitions.
  double totalVolume(Iterable<SetEntry> sets) {
    return sets.fold(0, (sum, s) => sum + s.weightKg * s.reps);
  }

  ExerciseProgressPoint progressPoint({
    required DateTime date,
    required List<SetEntry> sets,
  }) {
    var maxWeight = 0.0;
    var bestOneRm = 0.0;
    var maxDuration = 0;
    var totalDuration = 0;
    for (final set in sets) {
      maxWeight = max(maxWeight, set.weightKg);
      bestOneRm = max(bestOneRm, estimateOneRm(set.weightKg, set.reps));
      final duration = set.durationSeconds ?? 0;
      maxDuration = max(maxDuration, duration);
      totalDuration += duration;
    }
    return ExerciseProgressPoint(
      date: date,
      maxWeightKg: maxWeight,
      totalVolume: totalVolume(sets),
      estimatedOneRm: bestOneRm,
      maxDurationSeconds: maxDuration,
      totalDurationSeconds: totalDuration,
    );
  }
}
