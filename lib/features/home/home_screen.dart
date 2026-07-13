import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../domain/models/muscle_groups.dart';
import '../../domain/models/progress_models.dart';
import '../../domain/models/template_models.dart';
import '../../widgets/stat_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _startTemplate(
      BuildContext context, WidgetRef ref, TemplateWithExercises template) async {
    final controller = ref.read(activeSessionProvider.notifier);
    if (controller.hasActiveSession) {
      final replace = await _confirmReplace(context);
      if (replace != true) return;
      await controller.discard();
    }
    await controller.startFromTemplate(template);
    if (context.mounted) context.push('/session');
  }

  Future<void> _startFree(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(activeSessionProvider.notifier);
    if (controller.hasActiveSession) {
      final replace = await _confirmReplace(context);
      if (replace != true) return;
      await controller.discard();
    }
    controller.startFree();
    if (context.mounted) context.push('/session');
  }

  /// Choix de la couleur d'accent de l'application.
  Future<void> _showAccentPicker(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final current = ref.watch(themeSettingsProvider).accent;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Couleur de l\'application',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final accent in AppAccent.values)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () => ref
                                  .read(themeSettingsProvider.notifier)
                                  .setAccent(accent),
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accent.accent,
                                  border: accent == current
                                      ? Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          width: 3)
                                      : null,
                                ),
                                child: accent == current
                                    ? const Icon(Icons.check,
                                        color: Colors.white)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              accent.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: accent == current
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _confirmReplace(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Séance en cours'),
        content: const Text(
            'Une séance est déjà en cours. La remplacer supprimera les séries non sauvegardées.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remplacer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);
    final templatesAsync = ref.watch(templatesProvider);
    final summariesAsync = ref.watch(sessionSummariesProvider);
    final themeSettings = ref.watch(themeSettingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        actions: [
          IconButton(
            tooltip: 'Couleur de l\'application',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showAccentPicker(context, ref),
          ),
          IconButton(
            tooltip: 'Basculer le thème',
            icon: Icon(themeSettings.mode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
            onPressed: () =>
                ref.read(themeSettingsProvider.notifier).toggleMode(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            formatDayFull(DateTime.now()).capitalized(),
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Prêt à t\'entraîner ?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),

          // Séance en cours
          if (activeSession != null)
            Card(
              color: scheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SÉANCE EN COURS',
                      style: TextStyle(
                        color: scheme.onPrimary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activeSession.name,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activeSession.totalDoneSets} série(s) validée(s) · '
                      'démarrée à ${formatTime(activeSession.startedAt)}',
                      style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.9)),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.tonalIcon(
                      onPressed: () => context.push('/session'),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reprendre la séance'),
                    ),
                  ],
                ),
              ),
            ),

          // Stats de la semaine
          summariesAsync.maybeWhen(
            data: (summaries) {
              final now = DateTime.now();
              final weekStart = dayKey(now)
                  .subtract(Duration(days: now.weekday - 1));
              final thisWeek = summaries
                  .where((s) => !s.session.date.isBefore(weekStart))
                  .toList();
              final volume =
                  thisWeek.fold<double>(0, (sum, s) => sum + s.totalVolume);
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'Séances cette semaine',
                        value: '${thisWeek.length}',
                        icon: Icons.fitness_center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatTile(
                        label: 'Volume cette semaine',
                        value: formatVolume(volume),
                        icon: Icons.stacked_line_chart,
                      ),
                    ),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),

          // Un ou deux records personnels, qui tournent chaque jour.
          ref.watch(prHighlightsProvider).maybeWhen(
                data: (highlights) => highlights.isEmpty
                    ? const SizedBox.shrink()
                    : _PrHighlightsCard(highlights: highlights),
                orElse: () => const SizedBox.shrink(),
              ),

          const SizedBox(height: 12),
          const Text(
            'Démarrer une séance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),

          templatesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text('Erreur : $error'),
            data: (templates) => Column(
              children: [
                for (final template in templates)
                  _TemplateStartCard(
                    template: template,
                    onStart: () => _startTemplate(context, ref, template),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _startFree(context, ref),
            icon: const Icon(Icons.bolt),
            label: const Text('Séance libre'),
          ),

          // Dernière séance
          summariesAsync.maybeWhen(
            data: (summaries) {
              if (summaries.isEmpty) return const SizedBox.shrink();
              final last = summaries.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Dernière séance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            scheme.primary.withValues(alpha: 0.15),
                        child: Icon(Icons.check, color: scheme.primary),
                      ),
                      title: Text(last.session.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${formatDateShort(last.session.date)} · '
                        '${last.setCount} séries · '
                        '${formatVolume(last.totalVolume)}',
                      ),
                    ),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Carte compacte « records du jour » : deux PR maximum, tirés au sort de
/// façon déterministe par jour pour varier sans surcharger l'accueil.
class _PrHighlightsCard extends StatelessWidget {
  const _PrHighlightsCard({required this.highlights});

  final List<PrHighlight> highlights;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final today = dayKey(DateTime.now());
    final shuffled = [...highlights]
      ..shuffle(Random(today.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay));
    final picks = shuffled.take(2).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: scheme.primary, size: 18),
                const SizedBox(width: 6),
                Text(
                  'TES RECORDS',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < picks.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          picks[i].exerciseName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!picks[i].isDuration && picks[i].maxOneRm > 0)
                          Text(
                            '1RM estimé ${formatKg(picks[i].maxOneRm)}',
                            style: TextStyle(
                                color: scheme.onSurfaceVariant, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    picks[i].isDuration
                        ? formatTimer(picks[i].maxDurationSeconds)
                        : formatKg(picks[i].maxWeightKg),
                    style: numberStyle(context, size: 20),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TemplateStartCard extends StatelessWidget {
  const _TemplateStartCard({required this.template, required this.onStart});

  final TemplateWithExercises template;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muscles = sortedMuscleSlugs(
            template.exercises.expand((e) => e.exercise.muscleSlugs))
        .map((s) => muscleGroupBySlug(s).label)
        .join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.template.name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${template.exercises.length} exercices'
                    '${muscles.isEmpty ? '' : ' · $muscles'}',
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onStart,
              child: const Text('Démarrer'),
            ),
          ],
        ),
      ),
    );
  }
}
