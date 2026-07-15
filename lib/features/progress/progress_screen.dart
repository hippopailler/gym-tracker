import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../domain/models/exercise_models.dart';
import '../../domain/models/muscle_groups.dart';
import '../../domain/models/progress_models.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/stat_tile.dart';

enum _Metric {
  maxWeight('Poids max'),
  volume('Volume'),
  oneRm('1RM estimé'),
  maxDuration('Durée max'),
  totalDuration('Durée totale');

  const _Metric(this.label);
  final String label;

  double valueOf(ExerciseProgressPoint point) => switch (this) {
        _Metric.maxWeight => point.maxWeightKg,
        _Metric.volume => point.totalVolume,
        _Metric.oneRm => point.estimatedOneRm,
        _Metric.maxDuration => point.maxDurationSeconds.toDouble(),
        _Metric.totalDuration => point.totalDurationSeconds.toDouble(),
      };

  /// Métriques pertinentes selon le type d'exercice.
  static List<_Metric> availableFor({required bool isDuration}) => isDuration
      ? const [_Metric.maxDuration, _Metric.totalDuration]
      : const [_Metric.maxWeight, _Metric.volume, _Metric.oneRm];
}

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  String? _selectedGroupSlug;
  int? _selectedExerciseId;
  _Metric _metric = _Metric.maxWeight;

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);
    final withData =
        ref.watch(exercisesWithDataProvider).valueOrNull ?? const <int>{};

    return Scaffold(
      appBar: AppBar(title: const Text('Progression')),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (allExercises) {
          // Seuls les exercices déjà pratiqués sont proposés : inutile de
          // noyer le filtre avec le reste du catalogue.
          final exercises = [
            for (final e in allExercises)
              if (withData.contains(e.exercise.id)) e,
          ];
          if (exercises.isEmpty) {
            return const EmptyState(
              icon: Icons.show_chart,
              title: 'Pas encore de données',
              message:
                  'Termine une première séance pour voir ta progression ici.',
            );
          }

          // Groupes ayant au moins un exercice, dans l'ordre du catalogue.
          final groups = kMuscleGroups
              .where((g) => exercises.any((e) => e.worksGroup(g.slug)))
              .toList();
          final selectedGroup = groups.any((g) => g.slug == _selectedGroupSlug)
              ? _selectedGroupSlug!
              : groups.first.slug;
          final inGroup =
              exercises.where((e) => e.worksGroup(selectedGroup)).toList();
          final selectedId =
              inGroup.any((e) => e.exercise.id == _selectedExerciseId)
                  ? _selectedExerciseId!
                  : inGroup.first.exercise.id;
          final selectedDetail =
              inGroup.firstWhere((e) => e.exercise.id == selectedId);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final group in groups)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          avatar: Icon(group.icon, size: 16),
                          label: Text(group.label),
                          selected: selectedGroup == group.slug,
                          onSelected: (_) => setState(() {
                            _selectedGroupSlug = group.slug;
                            _selectedExerciseId = null;
                          }),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _ExerciseSelector(
                      key: ValueKey('selector-$selectedGroup'),
                      exercises: inGroup,
                      selectedId: selectedId,
                      onChanged: (id) =>
                          setState(() => _selectedExerciseId = id),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    tooltip: 'Comparer avec un autre exercice',
                    icon: const Icon(Icons.ssid_chart),
                    onPressed: () =>
                        context.push('/progress/compare?a=$selectedId'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ProgressBody(
                  exerciseId: selectedId,
                  isDuration:
                      selectedDetail.isDuration || selectedDetail.isCardio,
                  metric: _metric,
                  onMetricChanged: (m) => setState(() => _metric = m)),
            ],
          );
        },
      ),
    );
  }
}

class _ExerciseSelector extends StatelessWidget {
  const _ExerciseSelector({
    super.key,
    required this.exercises,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ExerciseDetail> exercises;
  final int selectedId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      decoration: const InputDecoration(labelText: 'Exercice'),
      items: [
        for (final detail in exercises)
          DropdownMenuItem(
            value: detail.exercise.id,
            child: Text(
              '${detail.exercise.name} — ${detail.exercise.equipment}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (id) {
        if (id != null) onChanged(id);
      },
    );
  }
}

class _ProgressBody extends ConsumerWidget {
  const _ProgressBody({
    required this.exerciseId,
    required this.isDuration,
    required this.metric,
    required this.onMetricChanged,
  });

  final int exerciseId;
  final bool isDuration;
  final _Metric metric;
  final ValueChanged<_Metric> onMetricChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(exerciseProgressProvider(exerciseId));
    final metrics = _Metric.availableFor(isDuration: isDuration);
    final activeMetric = metrics.contains(metric) ? metric : metrics.first;

    return progressAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text('Erreur : $error'),
      data: (points) {
        if (points.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 32),
            child: EmptyState(
              icon: Icons.insights,
              title: 'Pas encore de données',
              message:
                  'Termine une séance avec cet exercice pour voir ta progression.',
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDuration)
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      label: 'Record',
                      value: formatTimer(
                          points.map((p) => p.maxDurationSeconds).reduce(max)),
                      icon: Icons.emoji_events_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      label: 'Dernier cumul',
                      value: formatTimer(points.last.totalDurationSeconds),
                      icon: Icons.timer_outlined,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      label: 'Record',
                      value:
                          formatKg(points.map((p) => p.maxWeightKg).reduce(max)),
                      icon: Icons.emoji_events_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      label: '1RM estimé (Epley)',
                      value: formatKg(
                          points.map((p) => p.estimatedOneRm).reduce(max)),
                      icon: Icons.bolt,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      label: 'Dernier volume',
                      value: formatVolume(points.last.totalVolume),
                      icon: Icons.stacked_bar_chart,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            SegmentedButton<_Metric>(
              segments: [
                for (final m in metrics)
                  ButtonSegment(value: m, label: Text(m.label)),
              ],
              selected: {activeMetric},
              onSelectionChanged: (selection) =>
                  onMetricChanged(selection.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: 20),
            _ProgressChart(points: points, metric: activeMetric),
            const SizedBox(height: 12),
            Text(
              '${points.length} séance(s) enregistrée(s) avec cet exercice.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressChart extends StatelessWidget {
  const _ProgressChart({required this.points, required this.metric});

  final List<ExerciseProgressPoint> points;
  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), metric.valueOf(points[i])),
    ];
    final labelInterval = max(1, (points.length / 4).ceil());

    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          minX: -0.3,
          maxX: (points.length - 1) + 0.3,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: scheme.onSurface.withValues(alpha: 0.07),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, meta) => Text(
                  meta.formattedValue,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: labelInterval.toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 ||
                      index >= points.length ||
                      (value - index).abs() > 0.01) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      formatDayMonth(points[index].date),
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              preventCurveOverShooting: true,
              barWidth: 3,
              color: scheme.primary,
              dotData: FlDotData(
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: scheme.primary,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primary.withValues(alpha: 0.25),
                    scheme.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
