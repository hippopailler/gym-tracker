import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../domain/models/muscle_groups.dart';
import 'add_exercise_sheet.dart';

/// Onglet « Exercices » : un carreau par groupe musculaire, avec le nombre
/// d'exercices disponibles. Tap → liste des exercices du groupe.
class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Exercices')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddExerciseSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouvel exercice'),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (exercises) {
          final countBySlug = <String, int>{};
          for (final detail in exercises) {
            for (final slug in detail.muscleSlugs) {
              countBySlug[slug] = (countBySlug[slug] ?? 0) + 1;
            }
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.45,
            ),
            itemCount: kMuscleGroups.length,
            itemBuilder: (context, index) {
              final group = kMuscleGroups[index];
              return _MuscleGroupCard(
                group: group,
                exerciseCount: countBySlug[group.slug] ?? 0,
                onTap: () => context.push('/exercises/${group.slug}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _MuscleGroupCard extends StatelessWidget {
  const _MuscleGroupCard({
    required this.group,
    required this.exerciseCount,
    required this.onTap,
  });

  final MuscleGroup group;
  final int exerciseCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(group.icon, color: scheme.primary, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$exerciseCount exercice${exerciseCount > 1 ? 's' : ''}',
                    style: TextStyle(
                        fontSize: 12, color: scheme.onSurfaceVariant),
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
