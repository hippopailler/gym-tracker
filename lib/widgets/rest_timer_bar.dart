import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/formats.dart';
import '../core/providers.dart';
import '../core/theme.dart';

/// Barre de chrono affichée en bas de la séance active : grand compteur,
/// progression, boutons −15 s / +15 s / Passer. Sert pour le repos entre
/// les séries et pour l'exécution d'un exercice en durée (le nom de
/// l'exercice remplace alors « REPOS » et le bouton valide la série).
class RestTimerBar extends ConsumerWidget {
  const RestTimerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(restTimerProvider);
    final scheme = Theme.of(context).colorScheme;
    if (!timer.isActive) return const SizedBox.shrink();

    final isExercise = timer.isExercise;

    return Material(
      color: scheme.surface,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: timer.progress,
                  minHeight: 5,
                  backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    isExercise ? Icons.timer : Icons.hourglass_bottom,
                    color: scheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isExercise ? timer.exerciseName!.toUpperCase() : 'REPOS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Text(
                    formatTimer(timer.remainingSeconds),
                    style: numberStyle(context, size: 44, color: scheme.primary),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          ref.read(restTimerProvider.notifier).addSeconds(-15),
                      child: const Text('−15 s'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          ref.read(restTimerProvider.notifier).addSeconds(15),
                      child: const Text('+15 s'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () =>
                          ref.read(restTimerProvider.notifier).skip(),
                      icon: Icon(isExercise ? Icons.check : Icons.skip_next,
                          size: 20),
                      label: Text(isExercise ? 'Valider' : 'Passer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
