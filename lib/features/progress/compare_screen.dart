import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../domain/models/exercise_models.dart';
import '../../domain/models/progress_models.dart';
import '../../widgets/empty_state.dart';

enum _CompareMetric {
  maxWeight('Poids max'),
  oneRm('1RM estimé'),
  volume('Volume'),
  maxDuration('Durée max'),
  totalDuration('Durée totale');

  const _CompareMetric(this.label);
  final String label;

  double valueOf(ExerciseProgressPoint point) => switch (this) {
        _CompareMetric.maxWeight => point.maxWeightKg,
        _CompareMetric.oneRm => point.estimatedOneRm,
        _CompareMetric.volume => point.totalVolume,
        _CompareMetric.maxDuration => point.maxDurationSeconds.toDouble(),
        _CompareMetric.totalDuration => point.totalDurationSeconds.toDouble(),
      };

  static List<_CompareMetric> availableFor({required bool isDuration}) =>
      isDuration
          ? const [_CompareMetric.maxDuration, _CompareMetric.totalDuration]
          : const [
              _CompareMetric.maxWeight,
              _CompareMetric.oneRm,
              _CompareMetric.volume,
            ];
}

/// Comparaison de la progression de deux exercices sur un même graphique,
/// aligné sur les dates réelles des séances.
class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key, this.initialExerciseId});

  /// Exercice pré-sélectionné (venant de l'écran Progression).
  final int? initialExerciseId;

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  int? _idA;
  int? _idB;
  _CompareMetric _metric = _CompareMetric.maxWeight;

  bool _isDurationLike(ExerciseDetail d) => d.isDuration || d.isCardio;

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Comparer deux exercices')),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (exercises) {
          if (exercises.length < 2) {
            return const EmptyState(
              icon: Icons.ssid_chart,
              title: 'Pas assez d\'exercices',
              message: 'Il faut au moins deux exercices pour comparer.',
            );
          }

          final detailA = exercises.firstWhere(
            (e) => e.exercise.id == (_idA ?? widget.initialExerciseId),
            orElse: () => exercises.first,
          );
          final durationLike = _isDurationLike(detailA);
          // Le second exercice doit être du même « genre » de mesure
          // (kg×reps vs durée), sinon le graphique n'a pas de sens.
          final compatible = [
            for (final e in exercises)
              if (e.exercise.id != detailA.exercise.id &&
                  _isDurationLike(e) == durationLike)
                e,
          ];
          final detailB = compatible.isEmpty
              ? null
              : compatible.firstWhere(
                  (e) => e.exercise.id == _idB,
                  orElse: () => compatible.first,
                );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _ExerciseDropdown(
                label: 'Exercice A',
                exercises: exercises,
                selectedId: detailA.exercise.id,
                onChanged: (id) => setState(() {
                  _idA = id;
                  _idB = null;
                }),
              ),
              const SizedBox(height: 12),
              if (detailB == null)
                Text(
                  'Aucun autre exercice du même type à comparer.',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                )
              else ...[
                _ExerciseDropdown(
                  label: 'Exercice B',
                  exercises: compatible,
                  selectedId: detailB.exercise.id,
                  onChanged: (id) => setState(() => _idB = id),
                ),
                const SizedBox(height: 16),
                _CompareBody(
                  detailA: detailA,
                  detailB: detailB,
                  isDuration: durationLike,
                  metric: _metric,
                  onMetricChanged: (m) => setState(() => _metric = m),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ExerciseDropdown extends StatelessWidget {
  const _ExerciseDropdown({
    required this.label,
    required this.exercises,
    required this.selectedId,
    required this.onChanged,
  });

  final String label;
  final List<ExerciseDetail> exercises;
  final int selectedId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      key: ValueKey('$label-$selectedId'),
      initialValue: selectedId,
      decoration: InputDecoration(labelText: label),
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

class _CompareBody extends ConsumerWidget {
  const _CompareBody({
    required this.detailA,
    required this.detailB,
    required this.isDuration,
    required this.metric,
    required this.onMetricChanged,
  });

  final ExerciseDetail detailA;
  final ExerciseDetail detailB;
  final bool isDuration;
  final _CompareMetric metric;
  final ValueChanged<_CompareMetric> onMetricChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final progressA =
        ref.watch(exerciseProgressProvider(detailA.exercise.id));
    final progressB =
        ref.watch(exerciseProgressProvider(detailB.exercise.id));
    final metrics = _CompareMetric.availableFor(isDuration: isDuration);
    final activeMetric = metrics.contains(metric) ? metric : metrics.first;

    final pointsA = progressA.valueOrNull;
    final pointsB = progressB.valueOrNull;
    if (pointsA == null || pointsB == null) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (pointsA.isEmpty && pointsB.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: EmptyState(
          icon: Icons.insights,
          title: 'Pas encore de données',
          message: 'Aucune séance enregistrée avec ces deux exercices.',
        ),
      );
    }

    final colorA = scheme.primary;
    final colorB = scheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<_CompareMetric>(
          segments: [
            for (final m in metrics)
              ButtonSegment(value: m, label: Text(m.label)),
          ],
          selected: {activeMetric},
          onSelectionChanged: (selection) => onMetricChanged(selection.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 14),
        _Legend(
            name: detailA.exercise.name,
            color: colorA,
            sessionCount: pointsA.length),
        const SizedBox(height: 4),
        _Legend(
            name: detailB.exercise.name,
            color: colorB,
            sessionCount: pointsB.length),
        const SizedBox(height: 16),
        _CompareChart(
          pointsA: pointsA,
          pointsB: pointsB,
          metric: activeMetric,
          colorA: colorA,
          colorB: colorB,
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.name,
    required this.color,
    required this.sessionCount,
  });

  final String name;
  final Color color;
  final int sessionCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(name,
              style: const TextStyle(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis),
        ),
        Text(
          '$sessionCount séance(s)',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
        ),
      ],
    );
  }
}

class _CompareChart extends StatelessWidget {
  const _CompareChart({
    required this.pointsA,
    required this.pointsB,
    required this.metric,
    required this.colorA,
    required this.colorB,
  });

  final List<ExerciseProgressPoint> pointsA;
  final List<ExerciseProgressPoint> pointsB;
  final _CompareMetric metric;
  final Color colorA;
  final Color colorB;

  /// Axe X = jours écoulés depuis la première séance des deux courbes,
  /// pour aligner les exercices sur les dates réelles.
  double _dayX(DateTime date, DateTime origin) =>
      date.difference(origin).inHours / 24.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final allDates = [
      for (final p in pointsA) p.date,
      for (final p in pointsB) p.date,
    ]..sort();
    final origin = allDates.first;
    final maxDay = _dayX(allDates.last, origin);

    LineChartBarData line(
        List<ExerciseProgressPoint> points, Color color) {
      return LineChartBarData(
        spots: [
          for (final p in points) FlSpot(_dayX(p.date, origin), metric.valueOf(p)),
        ],
        isCurved: true,
        curveSmoothness: 0.25,
        preventCurveOverShooting: true,
        barWidth: 3,
        color: color,
        dotData: FlDotData(
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
            radius: 3.5,
            color: color,
            strokeWidth: 0,
          ),
        ),
      );
    }

    final labelInterval = max(1.0, maxDay / 4);

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minX: -maxDay * 0.03 - 0.3,
          maxX: maxDay * 1.03 + 0.3,
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
                interval: labelInterval,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value > maxDay) {
                    return const SizedBox.shrink();
                  }
                  final date = origin.add(Duration(hours: (value * 24).round()));
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      formatDayMonth(date),
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
            if (pointsA.isNotEmpty) line(pointsA, colorA),
            if (pointsB.isNotEmpty) line(pointsB, colorB),
          ],
        ),
      ),
    );
  }
}
