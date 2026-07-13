import '../../data/database/database.dart';

/// Résumé d'une séance passée pour les listes et le calendrier.
class SessionSummary {
  const SessionSummary({
    required this.session,
    required this.exerciseCount,
    required this.setCount,
    required this.totalVolume,
  });

  final WorkoutSession session;
  final int exerciseCount;
  final int setCount;

  /// Volume total en kg (somme des poids × répétitions).
  final double totalVolume;
}

/// Un exercice d'une séance passée avec toutes ses séries.
class SessionExerciseDetail {
  const SessionExerciseDetail({
    required this.sessionExerciseId,
    required this.exercise,
    required this.sets,
  });

  final int sessionExerciseId;
  final Exercise exercise;
  final List<SetEntry> sets;
}

/// Détail complet d'une séance passée.
class SessionDetail {
  const SessionDetail({required this.session, required this.exercises});

  final WorkoutSession session;
  final List<SessionExerciseDetail> exercises;
}

/// Brouillon d'une séance terminée, prêt à être persisté.
class CompletedSessionDraft {
  const CompletedSessionDraft({
    required this.date,
    required this.templateId,
    required this.name,
    required this.notes,
    required this.durationSeconds,
    required this.exercises,
  });

  final DateTime date;
  final int? templateId;
  final String name;
  final String notes;
  final int durationSeconds;
  final List<CompletedExerciseDraft> exercises;
}

class CompletedExerciseDraft {
  const CompletedExerciseDraft({required this.exerciseId, required this.sets});

  final int exerciseId;
  final List<CompletedSetDraft> sets;
}

class CompletedSetDraft {
  const CompletedSetDraft({
    required this.weightKg,
    required this.reps,
    this.rpe,
    this.restTakenSeconds,
    this.durationSeconds,
  });

  final double weightKg;
  final int reps;
  final double? rpe;
  final int? restTakenSeconds;
  final int? durationSeconds;
}

/// Série ajoutée à un exercice existant depuis l'éditeur de séance passée.
class NewSetForExercise {
  const NewSetForExercise({
    required this.sessionExerciseId,
    required this.weightKg,
    required this.reps,
    this.durationSeconds,
  });

  final int sessionExerciseId;
  final double weightKg;
  final int reps;
  final int? durationSeconds;
}

/// Correction d'une série existante depuis l'éditeur de séance passée.
class SetCorrection {
  const SetCorrection({
    required this.setId,
    required this.weightKg,
    required this.reps,
    this.durationSeconds,
  });

  final int setId;
  final double weightKg;
  final int reps;
  final int? durationSeconds;
}
