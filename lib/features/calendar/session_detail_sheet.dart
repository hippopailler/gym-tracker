import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../domain/models/session_models.dart';

/// Détail complet d'une séance passée en bottom sheet.
Future<void> showSessionDetailSheet(BuildContext context, int sessionId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _SessionDetailSheet(sessionId: sessionId),
  );
}

class _SessionDetailSheet extends ConsumerWidget {
  const _SessionDetailSheet({required this.sessionId});

  final int sessionId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette séance ?'),
        content: const Text(
            'La séance et toutes ses séries seront définitivement supprimées.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(sessionRepositoryProvider).deleteSession(sessionId);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return FutureBuilder<SessionDetail?>(
          future: ref.read(sessionRepositoryProvider).getDetail(sessionId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final detail = snapshot.data!;
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        detail.session.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Corriger la séance',
                      onPressed: () {
                        Navigator.of(context).pop();
                        GoRouter.of(context)
                            .push('/history/edit/$sessionId');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Supprimer la séance',
                      onPressed: () => _confirmDelete(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatDayFull(detail.session.date).capitalized()} · '
                  '${formatTime(detail.session.date)} · '
                  '${formatDuration(detail.session.durationSeconds)}',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                if (detail.session.notes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(detail.session.notes),
                  ),
                ],
                const SizedBox(height: 16),
                for (final exercise in detail.exercises) ...[
                  Text(
                    exercise.exercise.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  for (final set in exercise.sets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 26,
                            child: Text(
                              '${set.setNumber}.',
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            set.durationSeconds != null
                                ? formatTimer(set.durationSeconds!)
                                : '${formatKg(set.weightKg)} × ${set.reps}',
                            style: numberStyle(context, size: 15,
                                weight: FontWeight.w700),
                          ),
                          if (set.rpe != null) ...[
                            const SizedBox(width: 10),
                            Text(
                              'RPE ${set.rpe}',
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 13),
                            ),
                          ],
                          const Spacer(),
                          if (set.restTakenSeconds != null)
                            Text(
                              'repos ${formatTimer(set.restTakenSeconds!)}',
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
