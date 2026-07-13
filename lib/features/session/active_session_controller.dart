import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../domain/models/active_session.dart';
import '../../domain/models/exercise_models.dart';
import '../../domain/models/progress_models.dart';
import '../../domain/models/template_models.dart';

/// Pilote la séance en cours : démarrage, validation des séries,
/// chrono de repos, records, sauvegarde finale.
///
/// L'état vit au niveau de l'app (provider global) et chaque mutation est
/// sauvegardée en base : la séance survit à la navigation ET à la
/// fermeture de l'app (restaurée au prochain lancement).
class ActiveSessionController extends StateNotifier<ActiveSessionState?> {
  ActiveSessionController(this._ref) : super(null) {
    _restore();
  }

  final Ref _ref;

  bool get hasActiveSession => state != null;

  /// Restaure la séance interrompue par une fermeture de l'app, le cas
  /// échéant.
  Future<void> _restore() async {
    final repo = _ref.read(sessionRepositoryProvider);
    final payload = await repo.loadActiveDraft();
    if (payload == null || state != null) return;
    try {
      final exercises = await _ref.read(exerciseRepositoryProvider)
          .watchAll()
          .first;
      final byId = {for (final e in exercises) e.exercise.id: e};
      state = ActiveSessionState.fromJson(
        (jsonDecode(payload) as Map).cast<String, dynamic>(),
        (id) => byId[id],
      );
    } catch (_) {
      // Instantané illisible (version antérieure…) : on l'abandonne.
      await repo.clearActiveDraft();
    }
  }

  /// Sauvegarde l'instantané de la séance (appelé après chaque mutation).
  void _persist() {
    final current = state;
    final repo = _ref.read(sessionRepositoryProvider);
    if (current == null) {
      repo.clearActiveDraft();
    } else {
      repo.saveActiveDraft(jsonEncode(current.toJson()));
    }
  }

  /// Démarre une séance depuis un template, avec les suggestions de
  /// progression calculées à partir des dernières performances.
  Future<void> startFromTemplate(TemplateWithExercises template) async {
    final exercises = <ActiveExercise>[];
    for (final item in template.exercises) {
      exercises.add(await _buildExercise(
        detail: item.exercise,
        targetSets: item.link.targetSets,
        targetReps: item.link.targetReps,
        restSeconds: item.link.restSeconds,
      ));
    }
    state = ActiveSessionState(
      name: template.template.name,
      templateId: template.template.id,
      startedAt: DateTime.now(),
      exercises: exercises,
    );
    _persist();
  }

  /// Démarre une séance libre, sans template.
  void startFree() {
    state = ActiveSessionState(
      name: 'Séance libre',
      templateId: null,
      startedAt: DateTime.now(),
      exercises: const [],
    );
    _persist();
  }

  Future<ActiveExercise> _buildExercise({
    required ExerciseDetail detail,
    required int targetSets,
    required int targetReps,
    required int restSeconds,
  }) async {
    final repo = _ref.read(sessionRepositoryProvider);
    final progression = _ref.read(progressionServiceProvider);
    final lastSets = await repo.lastSetsForExercise(detail.exercise.id);
    final bests = await repo.personalBests(detail.exercise.id);
    final lastNote = await repo.lastNoteForExercise(detail.exercise.id);
    // Pas de suggestion de progression pour le cardio : on repart de la
    // dernière performance.
    final suggestion = detail.isCardio
        ? null
        : detail.isDuration
            ? progression.suggestDuration(
                lastSets: lastSets, targetSeconds: targetReps)
            : progression.suggest(lastSets: lastSets, targetReps: targetReps);
    return ActiveExercise(
      detail: detail,
      targetSets: targetSets,
      targetReps: targetReps,
      restSeconds: restSeconds,
      suggestion: suggestion,
      bests: bests,
      lastNote: lastNote,
      lastSets: [
        for (final set in lastSets)
          LastSetData(
            weightKg: set.weightKg,
            reps: set.reps,
            durationSeconds: set.durationSeconds,
            distanceMeters: set.distanceMeters,
          ),
      ],
      sets: List.generate(targetSets, (_) => const ActiveSet()),
    );
  }

  /// Note libre sur un exercice de la séance (réglages machine…).
  void setExerciseNote(int exerciseIndex, String note) {
    _updateExercise(
        exerciseIndex, (exercise) => exercise.copyWith(note: note.trim()));
    _persist();
  }

  /// Ajoute un exercice à la volée (séance libre ou complément).
  Future<void> addExercise(ExerciseDetail detail) async {
    final current = state;
    if (current == null) return;
    if (current.exercises.any((e) => e.exercise.id == detail.exercise.id)) {
      return;
    }
    final added = await _buildExercise(
      detail: detail,
      targetSets: detail.isCardio ? 1 : 3,
      targetReps: detail.isCardio
          ? 600
          : detail.isDuration
              ? 30
              : 10,
      restSeconds: detail.exercise.defaultRestSeconds,
    );
    state = current.copyWith(exercises: [...current.exercises, added]);
    _persist();
  }

  void removeExercise(int exerciseIndex) {
    final current = state;
    if (current == null) return;
    final exercises = [...current.exercises]..removeAt(exerciseIndex);
    state = current.copyWith(exercises: exercises);
    _persist();
  }

  void addSet(int exerciseIndex) {
    _updateExercise(exerciseIndex, (exercise) {
      return exercise.copyWith(sets: [...exercise.sets, const ActiveSet()]);
    });
    _persist();
  }

  /// Change le temps de repos de l'exercice à la volée.
  void updateRestSeconds(int exerciseIndex, int seconds) {
    _updateExercise(exerciseIndex,
        (exercise) => exercise.copyWith(restSeconds: seconds.clamp(5, 900)));
    _persist();
  }

  /// Valide une série : enregistre la performance, détecte un éventuel
  /// record personnel et lance le chrono de repos.
  ///
  /// Retourne le record battu, à célébrer côté UI. 🎉
  PrCelebration? validateSet(
    int exerciseIndex,
    int setIndex, {
    required double weightKg,
    required int reps,
    int? durationSeconds,
    double? distanceMeters,
    double? rpe,
  }) {
    final current = state;
    if (current == null ||
        exerciseIndex >= current.exercises.length ||
        setIndex >= current.exercises[exerciseIndex].sets.length) {
      return null;
    }
    final exercise = current.exercises[exerciseIndex];

    final celebration = _detectPr(
      exercise: exercise,
      weightKg: weightKg,
      reps: reps,
      durationSeconds: durationSeconds,
    );

    _updateSet(
      exerciseIndex,
      setIndex,
      (set) => set.copyWith(
        weightKg: weightKg,
        reps: reps,
        rpe: rpe,
        durationSeconds: durationSeconds,
        distanceMeters: distanceMeters,
        isDone: true,
      ),
    );
    _updateExercise(exerciseIndex, (e) {
      final progression = _ref.read(progressionServiceProvider);
      return e.copyWith(
        bests: PersonalBests(
          maxWeightKg:
              weightKg > e.bests.maxWeightKg ? weightKg : e.bests.maxWeightKg,
          maxOneRm: progression.estimateOneRm(weightKg, reps) > e.bests.maxOneRm
              ? progression.estimateOneRm(weightKg, reps)
              : e.bests.maxOneRm,
          maxDurationSeconds:
              (durationSeconds ?? 0) > e.bests.maxDurationSeconds
                  ? durationSeconds!
                  : e.bests.maxDurationSeconds,
        ),
      );
    });
    _persist();

    final restSeconds = current.exercises[exerciseIndex].restSeconds;
    _ref.read(restTimerProvider.notifier).start(
          restSeconds,
          onComplete: (elapsed) =>
              _recordRestTaken(exerciseIndex, setIndex, elapsed),
        );
    return celebration;
  }

  /// Lance le chrono d'exécution d'un exercice en durée (gainage…). À la
  /// fin du décompte — ou quand l'utilisateur valide plus tôt — la série
  /// est validée automatiquement avec le temps effectué, ce qui enchaîne
  /// sur le chrono de repos.
  void startExerciseTimer(int exerciseIndex, int setIndex, int seconds) {
    final current = state;
    if (current == null || exerciseIndex >= current.exercises.length) return;
    final exerciseId = current.exercises[exerciseIndex].exercise.id;
    _ref.read(restTimerProvider.notifier).start(
          seconds,
          exerciseName: current.exercises[exerciseIndex].exercise.name,
          onComplete: (elapsed) {
            // L'index peut avoir bougé entre-temps (exercice retiré…) :
            // on retrouve l'exercice par son id au moment de la validation.
            final session = state;
            if (session == null) return;
            final index = session.exercises
                .indexWhere((e) => e.exercise.id == exerciseId);
            if (index < 0 ||
                setIndex >= session.exercises[index].sets.length ||
                session.exercises[index].sets[setIndex].isDone) {
              return;
            }
            final celebration = validateSet(
              index,
              setIndex,
              weightKg: 0,
              reps: 0,
              durationSeconds: elapsed.clamp(1, seconds),
            );
            if (celebration != null) {
              _ref.read(prCelebrationProvider.notifier).state = celebration;
            }
          },
        );
  }

  /// Un record n'est célébré que s'il bat un historique existant (pas de
  /// fausse fanfare à la toute première séance d'un exercice).
  PrCelebration? _detectPr({
    required ActiveExercise exercise,
    required double weightKg,
    required int reps,
    int? durationSeconds,
  }) {
    final name = exercise.exercise.name;
    if (exercise.isDuration) {
      final best = exercise.bests.maxDurationSeconds;
      if (best > 0 && (durationSeconds ?? 0) > best) {
        return PrCelebration(
          message:
              '🏆 Record battu : ${formatTimer(durationSeconds!)} à $name !',
        );
      }
      return null;
    }
    if (exercise.bests.maxWeightKg > 0 &&
        weightKg > exercise.bests.maxWeightKg) {
      return PrCelebration(
        message: '🏆 Record de poids : ${formatKg(weightKg)} à $name !',
      );
    }
    final oneRm =
        _ref.read(progressionServiceProvider).estimateOneRm(weightKg, reps);
    if (exercise.bests.maxOneRm > 0 && oneRm > exercise.bests.maxOneRm) {
      return PrCelebration(
        message:
            '🔥 Nouveau 1RM estimé : ${formatKg(oneRm)} à $name !',
      );
    }
    return null;
  }

  /// Rouvre une série validée pour la corriger.
  void reopenSet(int exerciseIndex, int setIndex) {
    final current = state;
    if (current == null) return;
    final set = current.exercises[exerciseIndex].sets[setIndex];
    _updateSet(exerciseIndex, setIndex, (_) => set.reopened());
    _persist();
  }

  void _recordRestTaken(int exerciseIndex, int setIndex, int elapsedSeconds) {
    final current = state;
    if (current == null ||
        exerciseIndex >= current.exercises.length ||
        setIndex >= current.exercises[exerciseIndex].sets.length) {
      return;
    }
    if (!current.exercises[exerciseIndex].sets[setIndex].isDone) return;
    _updateSet(exerciseIndex, setIndex,
        (set) => set.copyWith(restTakenSeconds: elapsedSeconds));
    _persist();
  }

  /// Sauvegarde la séance et réinitialise l'état.
  /// Retourne l'id de la séance créée, ou null si rien n'a été validé.
  Future<int?> finish({String notes = ''}) async {
    final current = state;
    if (current == null) return null;
    await _ref.read(restTimerProvider.notifier).cancel();
    final repo = _ref.read(sessionRepositoryProvider);
    final draft = current.toDraft(notes: notes);
    if (draft.exercises.isEmpty) {
      state = null;
      await repo.clearActiveDraft();
      return null;
    }
    final sessionId = await repo.saveCompleted(draft);
    state = null;
    await repo.clearActiveDraft();
    return sessionId;
  }

  /// Abandonne la séance sans rien sauvegarder.
  Future<void> discard() async {
    await _ref.read(restTimerProvider.notifier).cancel();
    state = null;
    await _ref.read(sessionRepositoryProvider).clearActiveDraft();
  }

  void _updateExercise(
      int exerciseIndex, ActiveExercise Function(ActiveExercise) transform) {
    final current = state;
    if (current == null || exerciseIndex >= current.exercises.length) return;
    final exercises = [...current.exercises];
    exercises[exerciseIndex] = transform(exercises[exerciseIndex]);
    state = current.copyWith(exercises: exercises);
  }

  void _updateSet(int exerciseIndex, int setIndex,
      ActiveSet Function(ActiveSet) transform) {
    _updateExercise(exerciseIndex, (exercise) {
      final sets = [...exercise.sets];
      sets[setIndex] = transform(sets[setIndex]);
      return exercise.copyWith(sets: sets);
    });
  }
}
