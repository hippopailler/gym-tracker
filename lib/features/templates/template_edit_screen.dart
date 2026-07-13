import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../domain/models/exercise_models.dart';
import '../../domain/models/template_models.dart';
import '../../widgets/exercise_picker_sheet.dart';

/// Création ([templateId] null) ou édition d'un template.
class TemplateEditScreen extends ConsumerStatefulWidget {
  const TemplateEditScreen({super.key, this.templateId});

  final int? templateId;

  @override
  ConsumerState<TemplateEditScreen> createState() =>
      _TemplateEditScreenState();
}

class _EditableItem {
  _EditableItem({
    required this.detail,
    required this.targetSets,
    required this.targetReps,
    required this.restSeconds,
  });

  final ExerciseDetail detail;
  int targetSets;
  int targetReps;
  int restSeconds;
}

class _TemplateEditScreenState extends ConsumerState<TemplateEditScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final List<_EditableItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.templateId;
    if (id != null) {
      final template =
          await ref.read(templateRepositoryProvider).getById(id);
      if (template != null && mounted) {
        _nameController.text = template.template.name;
        _descriptionController.text = template.template.description;
        _tagsController.text = template.template.tags;
        _items.addAll([
          for (final item in template.exercises)
            _EditableItem(
              detail: item.exercise,
              targetSets: item.link.targetSets,
              targetReps: item.link.targetReps,
              restSeconds: item.link.restSeconds,
            ),
        ]);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final detail = await showExercisePicker(context);
    if (detail == null) return;
    if (_items.any((i) => i.detail.exercise.id == detail.exercise.id)) return;
    setState(() {
      _items.add(_EditableItem(
        detail: detail,
        targetSets: 3,
        targetReps: 10,
        restSeconds: detail.exercise.defaultRestSeconds,
      ));
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donne un nom au template')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoute au moins un exercice')),
      );
      return;
    }
    await ref.read(templateRepositoryProvider).save(
          id: widget.templateId,
          name: name,
          description: _descriptionController.text.trim(),
          tags: _tagsController.text.trim(),
          items: [
            for (final item in _items)
              TemplateExerciseDraft(
                exerciseId: item.detail.exercise.id,
                targetSets: item.targetSets,
                targetReps: item.targetReps,
                restSeconds: item.restSeconds,
              ),
          ],
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templateId == null
            ? 'Nouveau template'
            : 'Modifier le template'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _save,
              child: const Text('Enregistrer'),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'push, force, débutant…',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Exercices',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _addExercise,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Ajouter'),
                    ),
                  ],
                ),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: _items.length,
                  onReorderItem: (oldIndex, newIndex) {
                    setState(() {
                      final item = _items.removeAt(oldIndex);
                      _items.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return _ExerciseEditTile(
                      key: ValueKey('item-${item.detail.exercise.id}'),
                      index: index,
                      item: item,
                      onChanged: () => setState(() {}),
                      onRemove: () =>
                          setState(() => _items.removeAt(index)),
                    );
                  },
                ),
                if (_items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Aucun exercice pour l\'instant.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ExerciseEditTile extends StatelessWidget {
  const _ExerciseEditTile({
    super.key,
    required this.index,
    required this.item,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final _EditableItem item;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.drag_indicator,
                    color: scheme.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.detail.exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _NumberField(
                        label: 'Séries',
                        value: item.targetSets,
                        onChanged: (value) {
                          item.targetSets = value;
                          onChanged();
                        },
                      ),
                      const SizedBox(width: 8),
                      _NumberField(
                        label: item.detail.isDuration ? 'Sec.' : 'Reps',
                        value: item.targetReps,
                        maxValue: item.detail.isDuration ? 900 : 99,
                        onChanged: (value) {
                          item.targetReps = value;
                          onChanged();
                        },
                      ),
                      const SizedBox(width: 8),
                      _NumberField(
                        label: 'Repos (s)',
                        value: item.restSeconds,
                        maxValue: 900,
                        onChanged: (value) {
                          item.restSeconds = value;
                          onChanged();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
              tooltip: 'Retirer',
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxValue = 99,
  });

  final String label;
  final int value;
  final int maxValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        initialValue: '$value',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: numberStyle(context, size: 15, weight: FontWeight.w700),
        decoration: InputDecoration(labelText: label, isDense: true),
        onChanged: (text) {
          final parsed = int.tryParse(text);
          if (parsed != null && parsed > 0 && parsed <= maxValue) {
            onChanged(parsed);
          }
        },
      ),
    );
  }
}
