import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../domain/models/template_models.dart';
import '../../widgets/empty_state.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  Future<void> _delete(
      BuildContext context, WidgetRef ref, TemplateWithExercises template) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer « ${template.template.name} » ?'),
        content: const Text(
            'Le template sera supprimé. Les séances déjà réalisées sont conservées.'),
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
      await ref
          .read(templateRepositoryProvider)
          .delete(template.template.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/templates/edit'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (templates) {
          if (templates.isEmpty) {
            return const EmptyState(
              icon: Icons.list_alt,
              title: 'Aucun template',
              message:
                  'Crée ton premier template de séance avec le bouton ci-dessous.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return _TemplateCard(
                template: template,
                onEdit: () => context
                    .push('/templates/edit?id=${template.template.id}'),
                onDuplicate: () => ref
                    .read(templateRepositoryProvider)
                    .duplicate(template.template.id),
                onDelete: () => _delete(context, ref, template),
              );
            },
          );
        },
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  final TemplateWithExercises template;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
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
                    if (template.template.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        template.template.description,
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                          label: Text('${template.exercises.length} exercices'),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        for (final tag in template.tags)
                          Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                    case 'duplicate':
                      onDuplicate();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  PopupMenuItem(value: 'duplicate', child: Text('Dupliquer')),
                  PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
