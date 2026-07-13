import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/exercise_models.dart';
import '../../domain/models/muscle_groups.dart';
import '../../widgets/empty_state.dart';
import 'add_exercise_sheet.dart';
import 'exercise_detail_sheet.dart';

/// Liste des exercices d'un groupe musculaire, avec ajout et suppression
/// (exercices personnalisés uniquement).
class GroupExercisesScreen extends ConsumerWidget {
  const GroupExercisesScreen({super.key, required this.slug});

  final String slug;

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ExerciseDetail detail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer « ${detail.exercise.name} » ?'),
        content: const Text(
            'L\'exercice sera retiré des templates et son historique de '
            'performances sera définitivement supprimé.'),
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
      await ref.read(exerciseRepositoryProvider).delete(detail.exercise.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = muscleGroupBySlug(slug);
    final exercisesAsync = ref.watch(exercisesProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(group.icon, color: scheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(group.label),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddExerciseSheet(context, initialGroup: slug),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (exercises) {
          final inGroup = exercises.where((e) => e.worksGroup(slug)).toList();
          if (inGroup.isEmpty) {
            return EmptyState(
              icon: group.icon,
              title: 'Aucun exercice',
              message:
                  'Ajoute ton premier exercice « ${group.label} » avec le bouton ci-dessous.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: inGroup.length,
            itemBuilder: (context, index) {
              final detail = inGroup[index];
              final otherGroups = detail.muscleSlugs
                  .where((s) => s != slug)
                  .map((s) => muscleGroupBySlug(s).label)
                  .join(' · ');
              return Card(
                child: ListTile(
                  title: Text(
                    detail.exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    detail.exercise.equipment +
                        (otherGroups.isEmpty ? '' : ' · aussi : $otherGroups'),
                  ),
                  leading: detail.exercise.isCustom
                      ? CircleAvatar(
                          backgroundColor:
                              scheme.primary.withValues(alpha: 0.15),
                          child: Icon(Icons.person,
                              color: scheme.primary, size: 20),
                        )
                      : CircleAvatar(
                          backgroundColor:
                              scheme.onSurface.withValues(alpha: 0.06),
                          child: Icon(group.icon,
                              color: scheme.onSurfaceVariant, size: 20),
                        ),
                  trailing: detail.exercise.isCustom
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Supprimer',
                          onPressed: () =>
                              _confirmDelete(context, ref, detail),
                        )
                      : null,
                  onTap: () => showExerciseDetailSheet(context, detail),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
