import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../domain/models/active_session.dart';
import '../../domain/models/progress_models.dart';
import '../../widgets/exercise_picker_sheet.dart';
import '../../widgets/rest_timer_bar.dart';
import '../../widgets/set_row.dart';

class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  Timer? _elapsedTicker;

  @override
  void initState() {
    super.initState();
    _elapsedTicker =
        Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _elapsedTicker?.cancel();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final session = ref.read(activeSessionProvider);
    final picked = await showMultiExercisePicker(
      context,
      alreadyPicked: {
        for (final e in session?.exercises ?? <ActiveExercise>[])
          e.exercise.id,
      },
    );
    if (picked == null) return;
    final controller = ref.read(activeSessionProvider.notifier);
    for (final exercise in picked) {
      await controller.addExercise(exercise);
    }
  }

  Future<void> _editRest(int exerciseIndex, int currentSeconds) async {
    var seconds = currentSeconds;
    final result = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Temps de repos'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                onPressed: () =>
                    setDialogState(() => seconds = (seconds - 15).clamp(15, 900)),
                icon: const Icon(Icons.remove),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(formatTimer(seconds),
                    style: numberStyle(context, size: 32)),
              ),
              IconButton.outlined(
                onPressed: () =>
                    setDialogState(() => seconds = (seconds + 15).clamp(15, 900)),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(seconds),
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      ref
          .read(activeSessionProvider.notifier)
          .updateRestSeconds(exerciseIndex, result);
    }
  }

  Future<void> _finishSession() async {
    final session = ref.read(activeSessionProvider);
    if (session == null) return;
    final controller = ref.read(activeSessionProvider.notifier);

    if (session.totalDoneSets == 0) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aucune série validée'),
          content: const Text(
              'Aucune série n\'a été validée. Abandonner la séance sans l\'enregistrer ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continuer la séance'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Abandonner'),
            ),
          ],
        ),
      );
      if (discard == true) {
        await controller.discard();
        if (mounted) context.go('/home');
      }
      return;
    }

    final notesController = TextEditingController();
    final duration = DateTime.now().difference(session.startedAt).inSeconds;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminer la séance ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${session.totalDoneSets} séries · '
              '${formatVolume(session.totalVolume)} · '
              '${formatDuration(duration)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Notes (optionnel)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      notesController.dispose();
      return;
    }
    await controller.finish(notes: notesController.text.trim());
    notesController.dispose();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Séance enregistrée 💪')),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);
    final timer = ref.watch(restTimerProvider);
    final scheme = Theme.of(context).colorScheme;

    // Record battu par une validation automatique (fin de chrono d'exercice).
    ref.listen(prCelebrationProvider, (_, celebration) {
      if (celebration != null) {
        showPrCelebration(context, celebration);
        ref.read(prCelebrationProvider.notifier).state = null;
      }
    });

    if (session == null) {
      // Séance terminée ou abandonnée : rien à afficher.
      return const Scaffold(body: SizedBox.shrink());
    }

    final elapsed = DateTime.now().difference(session.startedAt).inSeconds;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.name, style: const TextStyle(fontSize: 19)),
            Text(
              '${formatDuration(elapsed)} · ${session.totalDoneSets} séries',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _finishSession,
              child: const Text('Terminer'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          for (var i = 0; i < session.exercises.length; i++)
            _ExerciseCard(
              key: ValueKey('exercise-${session.exercises[i].exercise.id}'),
              exerciseIndex: i,
              exercise: session.exercises[i],
              onEditRest: () =>
                  _editRest(i, session.exercises[i].restSeconds),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addExercise,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un exercice'),
          ),
        ],
      ),
      bottomNavigationBar: timer.isActive ? const RestTimerBar() : null,
    );
  }
}

/// Affiche la bannière 🏆 + vibration d'un record personnel battu.
void showPrCelebration(BuildContext context, PrCelebration celebration) {
  HapticFeedback.heavyImpact();
  final scheme = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(
        celebration.message,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          color: scheme.onPrimary,
        ),
      ),
      backgroundColor: scheme.primary,
      duration: const Duration(seconds: 4),
    ));
}

class _ExerciseCard extends ConsumerWidget {
  const _ExerciseCard({
    super.key,
    required this.exerciseIndex,
    required this.exercise,
    required this.onEditRest,
  });

  final int exerciseIndex;
  final ActiveExercise exercise;
  final VoidCallback onEditRest;

  void _validate(BuildContext context, WidgetRef ref, int setIndex,
      double weight, int reps, int? duration) {
    final celebration =
        ref.read(activeSessionProvider.notifier).validateSet(
              exerciseIndex,
              setIndex,
              weightKg: weight,
              reps: reps,
              durationSeconds: duration,
            );
    if (celebration != null) {
      showPrCelebration(context, celebration);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final controller = ref.read(activeSessionProvider.notifier);
    final suggestion = exercise.suggestion;
    final isDuration = exercise.isDuration;

    // Valeurs proposées dans les champs : dernière série validée,
    // sinon la suggestion de progression.
    ActiveSet? lastDone;
    for (final set in exercise.sets) {
      if (set.isDone) lastDone = set;
    }
    final weightHint = lastDone?.weightKg ?? suggestion?.weightKg;
    final repsHint = lastDone?.reps ?? suggestion?.reps ?? exercise.targetReps;
    final durationHint = lastDone?.durationSeconds ??
        (suggestion != null && suggestion.isDuration
            ? suggestion.durationSeconds
            : exercise.targetReps);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exercise.name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${exercise.detail.muscleLabel} · '
                        'objectif ${exercise.targetSets} × ${exercise.targetReps}'
                        '${isDuration ? ' s' : ''}',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ActionChip(
                  avatar: Icon(Icons.timer_outlined,
                      size: 16, color: scheme.primary),
                  label: Text(formatTimer(exercise.restSeconds)),
                  onPressed: onEditRest,
                  tooltip: 'Modifier le temps de repos',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'remove') {
                      controller.removeExercise(exerciseIndex);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text('Retirer l\'exercice'),
                    ),
                  ],
                ),
              ],
            ),
            if (suggestion != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      suggestion.increased
                          ? Icons.trending_up
                          : Icons.replay,
                      size: 16,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        suggestion.isDuration
                            ? 'Suggestion : ${formatTimer(suggestion.durationSeconds)}'
                                '${suggestion.increased ? '  (+15 s 🔥)' : ''}'
                            : 'Suggestion : ${formatKg(suggestion.weightKg)} × ${suggestion.reps}'
                                '${suggestion.increased ? '  (+2,5 kg 🔥)' : ''}',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            for (var s = 0; s < exercise.sets.length; s++)
              SetRow(
                key: ValueKey(
                    'set-${exercise.exercise.id}-$s-${exercise.sets[s].isDone}'),
                setNumber: s + 1,
                set: exercise.sets[s],
                isDuration: isDuration,
                weightHint: exercise.lastSetFor(s)?.weightKg ?? weightHint,
                repsHint: exercise.lastSetFor(s)?.reps ?? repsHint,
                durationHint:
                    exercise.lastSetFor(s)?.durationSeconds ?? durationHint,
                lastPerformance: exercise.lastSetFor(s),
                onValidate: (weight, reps, duration) =>
                    _validate(context, ref, s, weight, reps, duration),
                onReopen: () => controller.reopenSet(exerciseIndex, s),
                onStartTimer: isDuration
                    ? (seconds) =>
                        controller.startExerciseTimer(exerciseIndex, s, seconds)
                    : null,
              ),
            TextButton.icon(
              onPressed: () => controller.addSet(exerciseIndex),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter une série'),
            ),
          ],
        ),
      ),
    );
  }
}
