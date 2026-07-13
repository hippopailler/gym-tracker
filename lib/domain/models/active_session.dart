import '../../data/database/database.dart';
import 'exercise_models.dart';
import 'progress_models.dart';
import 'session_models.dart';

/// Une série en cours de saisie pendant la séance active.
class ActiveSet {
  const ActiveSet({
    this.weightKg,
    this.reps,
    this.rpe,
    this.isDone = false,
    this.restTakenSeconds,
    this.durationSeconds,
  });

  final double? weightKg;
  final int? reps;
  final double? rpe;
  final bool isDone;
  final int? restTakenSeconds;

  /// Pour les exercices mesurés en secondes.
  final int? durationSeconds;

  ActiveSet copyWith({
    double? weightKg,
    int? reps,
    double? rpe,
    bool? isDone,
    int? restTakenSeconds,
    int? durationSeconds,
  }) {
    return ActiveSet(
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      isDone: isDone ?? this.isDone,
      restTakenSeconds: restTakenSeconds ?? this.restTakenSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  ActiveSet reopened() => ActiveSet(
        weightKg: weightKg,
        reps: reps,
        rpe: rpe,
        durationSeconds: durationSeconds,
        isDone: false,
      );

  Map<String, dynamic> toJson() => {
        'weightKg': weightKg,
        'reps': reps,
        'rpe': rpe,
        'isDone': isDone,
        'restTakenSeconds': restTakenSeconds,
        'durationSeconds': durationSeconds,
      };

  static ActiveSet fromJson(Map<String, dynamic> json) {
    return ActiveSet(
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      reps: json['reps'] as int?,
      rpe: (json['rpe'] as num?)?.toDouble(),
      isDone: json['isDone'] as bool? ?? false,
      restTakenSeconds: json['restTakenSeconds'] as int?,
      durationSeconds: json['durationSeconds'] as int?,
    );
  }
}

/// Performance d'une série lors de la dernière séance (pour la reprise
/// « comme la dernière fois » et les valeurs proposées par série).
class LastSetData {
  const LastSetData({
    required this.weightKg,
    required this.reps,
    this.durationSeconds,
  });

  final double weightKg;
  final int reps;
  final int? durationSeconds;

  Map<String, dynamic> toJson() => {
        'weightKg': weightKg,
        'reps': reps,
        'durationSeconds': durationSeconds,
      };

  static LastSetData fromJson(Map<String, dynamic> json) {
    return LastSetData(
      weightKg: (json['weightKg'] as num).toDouble(),
      reps: json['reps'] as int,
      durationSeconds: json['durationSeconds'] as int?,
    );
  }
}

/// Un exercice de la séance active.
class ActiveExercise {
  const ActiveExercise({
    required this.detail,
    required this.targetSets,
    required this.targetReps,
    required this.restSeconds,
    required this.sets,
    this.suggestion,
    this.lastSets = const [],
    this.bests = const PersonalBests(),
  });

  final ExerciseDetail detail;
  final int targetSets;

  /// Cible par série : répétitions, ou secondes pour un exercice en durée.
  final int targetReps;
  final int restSeconds;
  final PerformanceSuggestion? suggestion;

  /// Séries de la dernière séance, indexées par numéro de série.
  final List<LastSetData> lastSets;

  /// Records historiques, mis à jour au fil des séries validées.
  final PersonalBests bests;

  final List<ActiveSet> sets;

  Exercise get exercise => detail.exercise;

  bool get isDuration => detail.isDuration;

  int get doneSetCount => sets.where((s) => s.isDone).length;

  /// Dernière performance pour la série [setIndex], si disponible.
  LastSetData? lastSetFor(int setIndex) =>
      setIndex < lastSets.length ? lastSets[setIndex] : null;

  ActiveExercise copyWith({
    int? targetSets,
    int? targetReps,
    int? restSeconds,
    List<ActiveSet>? sets,
    PersonalBests? bests,
  }) {
    return ActiveExercise(
      detail: detail,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      restSeconds: restSeconds ?? this.restSeconds,
      suggestion: suggestion,
      lastSets: lastSets,
      bests: bests ?? this.bests,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exercise.id,
        'targetSets': targetSets,
        'targetReps': targetReps,
        'restSeconds': restSeconds,
        'suggestion': suggestion?.toJson(),
        'lastSets': [for (final s in lastSets) s.toJson()],
        'bests': bests.toJson(),
        'sets': [for (final s in sets) s.toJson()],
      };

  static ActiveExercise fromJson(
      Map<String, dynamic> json, ExerciseDetail detail) {
    return ActiveExercise(
      detail: detail,
      targetSets: json['targetSets'] as int,
      targetReps: json['targetReps'] as int,
      restSeconds: json['restSeconds'] as int,
      suggestion: json['suggestion'] == null
          ? null
          : PerformanceSuggestion.fromJson(
              (json['suggestion'] as Map).cast<String, dynamic>()),
      lastSets: [
        for (final s in (json['lastSets'] as List? ?? []))
          LastSetData.fromJson((s as Map).cast<String, dynamic>()),
      ],
      bests: json['bests'] == null
          ? const PersonalBests()
          : PersonalBests.fromJson(
              (json['bests'] as Map).cast<String, dynamic>()),
      sets: [
        for (final s in (json['sets'] as List))
          ActiveSet.fromJson((s as Map).cast<String, dynamic>()),
      ],
    );
  }
}

/// État complet de la séance en cours.
class ActiveSessionState {
  const ActiveSessionState({
    required this.name,
    required this.templateId,
    required this.startedAt,
    required this.exercises,
  });

  final String name;
  final int? templateId;
  final DateTime startedAt;
  final List<ActiveExercise> exercises;

  int get totalDoneSets =>
      exercises.fold(0, (sum, e) => sum + e.doneSetCount);

  double get totalVolume => exercises.fold(
        0,
        (sum, e) => e.sets
            .where((s) => s.isDone)
            .fold(sum, (v, s) => v + (s.weightKg ?? 0) * (s.reps ?? 0)),
      );

  ActiveSessionState copyWith({List<ActiveExercise>? exercises}) {
    return ActiveSessionState(
      name: name,
      templateId: templateId,
      startedAt: startedAt,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'templateId': templateId,
        'startedAt': startedAt.toIso8601String(),
        'exercises': [for (final e in exercises) e.toJson()],
      };

  /// Reconstruit la séance depuis un instantané JSON ; [resolveExercise]
  /// retrouve les exercices en base (ceux supprimés entre-temps sont ignorés).
  static ActiveSessionState fromJson(
    Map<String, dynamic> json,
    ExerciseDetail? Function(int exerciseId) resolveExercise,
  ) {
    final exercises = <ActiveExercise>[];
    for (final raw in json['exercises'] as List) {
      final map = (raw as Map).cast<String, dynamic>();
      final detail = resolveExercise(map['exerciseId'] as int);
      if (detail != null) {
        exercises.add(ActiveExercise.fromJson(map, detail));
      }
    }
    return ActiveSessionState(
      name: json['name'] as String,
      templateId: json['templateId'] as int?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      exercises: exercises,
    );
  }

  /// Convertit la séance en brouillon persistable : seules les séries
  /// validées sont conservées, les exercices vides sont ignorés.
  CompletedSessionDraft toDraft({required String notes}) {
    final now = DateTime.now();
    return CompletedSessionDraft(
      date: startedAt,
      templateId: templateId,
      name: name,
      notes: notes,
      durationSeconds: now.difference(startedAt).inSeconds,
      exercises: [
        for (final exercise in exercises)
          if (exercise.sets.any((s) => s.isDone))
            CompletedExerciseDraft(
              exerciseId: exercise.exercise.id,
              sets: [
                for (final set in exercise.sets)
                  if (set.isDone)
                    CompletedSetDraft(
                      weightKg: set.weightKg ?? 0,
                      reps: set.reps ?? 0,
                      rpe: set.rpe,
                      restTakenSeconds: set.restTakenSeconds,
                      durationSeconds: set.durationSeconds,
                    ),
              ],
            ),
      ],
    );
  }
}
