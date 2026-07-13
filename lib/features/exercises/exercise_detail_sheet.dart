import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../domain/models/exercise_models.dart';
import '../../domain/models/progress_models.dart';

/// Fiche d'un exercice : équipement, groupes travaillés, description et
/// tableau des records personnels datés.
Future<void> showExerciseDetailSheet(
    BuildContext context, ExerciseDetail detail) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _ExerciseDetailSheet(detail: detail),
  );
}

class _ExerciseDetailSheet extends ConsumerWidget {
  const _ExerciseDetailSheet({required this.detail});

  final ExerciseDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final recordsAsync =
        ref.watch(exerciseRecordsProvider(detail.exercise.id));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.exercise.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              '${detail.exercise.equipment} · ${detail.muscleLabel}',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
            if (detail.exercise.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(detail.exercise.description),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.emoji_events, color: scheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Records personnels',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            recordsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('Erreur : $error'),
              data: (records) => _RecordsTable(
                records: records,
                isDuration: detail.isDuration || detail.isCardio,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordsTable extends StatelessWidget {
  const _RecordsTable({required this.records, required this.isDuration});

  final ExerciseRecords records;
  final bool isDuration;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (records.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Aucune performance enregistrée pour le moment. '
          'Les records apparaîtront après ta première séance.',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      );
    }

    final rows = <_RecordRow>[
      if (isDuration && records.maxDuration != null)
        _RecordRow(
          label: 'Durée max',
          value: formatTimer(records.maxDuration!.value.toInt()),
          date: records.maxDuration!.date,
        ),
      if (!isDuration && records.maxWeight != null)
        _RecordRow(
          label: 'Poids max',
          value:
              '${formatKg(records.maxWeight!.value)} × ${records.maxWeight!.reps}',
          date: records.maxWeight!.date,
        ),
      if (!isDuration && records.bestOneRm != null)
        _RecordRow(
          label: '1RM estimé',
          value: formatKg(records.bestOneRm!.value),
          date: records.bestOneRm!.date,
        ),
      if (!isDuration && records.bestSessionVolume != null)
        _RecordRow(
          label: 'Volume record (séance)',
          value: formatVolume(records.bestSessionVolume!.value),
          date: records.bestSessionVolume!.date,
        ),
      _RecordRow(
        label: 'Séances réalisées',
        value: '${records.sessionCount}',
        date: null,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    rows[i].label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rows[i].value,
                        style: numberStyle(context, size: 17)),
                    if (rows[i].date != null)
                      Text(
                        formatDateShort(rows[i].date!),
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _RecordRow {
  const _RecordRow({required this.label, required this.value, this.date});

  final String label;
  final String value;
  final DateTime? date;
}
