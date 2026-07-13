import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../domain/models/exercise_models.dart';
import '../domain/models/muscle_groups.dart';

/// Feuille de sélection d'un exercice : recherche + filtre par groupe
/// musculaire (un exercice peut appartenir à plusieurs groupes).
Future<ExerciseDetail?> showExercisePicker(BuildContext context,
    {String? initialGroup}) {
  return showModalBottomSheet<ExerciseDetail>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ExercisePickerSheet(initialGroup: initialGroup),
  );
}

class _ExercisePickerSheet extends ConsumerStatefulWidget {
  const _ExercisePickerSheet({this.initialGroup});

  final String? initialGroup;

  @override
  ConsumerState<_ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<_ExercisePickerSheet> {
  String _query = '';
  String? _groupFilter;

  @override
  void initState() {
    super.initState();
    _groupFilter = widget.initialGroup;
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: TextField(
                autofocus: false,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un exercice…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: const Text('Tous'),
                      selected: _groupFilter == null,
                      onSelected: (_) => setState(() => _groupFilter = null),
                    ),
                  ),
                  for (final group in kMuscleGroups)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        avatar: Icon(group.icon, size: 16),
                        label: Text(group.label),
                        selected: _groupFilter == group.slug,
                        onSelected: (_) =>
                            setState(() => _groupFilter = group.slug),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: exercisesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Erreur : $error')),
                data: (exercises) {
                  final query = _query.toLowerCase();
                  final filtered = exercises
                      .where((e) =>
                          (_groupFilter == null ||
                              e.worksGroup(_groupFilter!)) &&
                          (query.isEmpty ||
                              e.exercise.name.toLowerCase().contains(query) ||
                              e.muscleLabel.toLowerCase().contains(query)))
                      .toList();
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun exercice trouvé.',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final detail = filtered[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(
                                detail.exercise.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (detail.exercise.isCustom) ...[
                              const SizedBox(width: 6),
                              const _CustomBadge(),
                            ],
                          ],
                        ),
                        subtitle: Text(
                            '${detail.exercise.equipment} · ${detail.muscleLabel}'),
                        trailing: const Icon(Icons.add_circle_outline),
                        onTap: () => Navigator.of(context).pop(detail),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CustomBadge extends StatelessWidget {
  const _CustomBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'perso',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: scheme.primary,
        ),
      ),
    );
  }
}
