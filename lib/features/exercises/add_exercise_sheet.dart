import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../data/database/tables.dart';
import '../../domain/models/muscle_groups.dart';

/// Formulaire de création d'un exercice personnalisé, rattachable à un ou
/// plusieurs groupes musculaires.
Future<void> showAddExerciseSheet(BuildContext context,
    {String? initialGroup}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _AddExerciseSheet(initialGroup: initialGroup),
  );
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  const _AddExerciseSheet({this.initialGroup});

  final String? initialGroup;

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
  final _nameController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedGroups = {};
  int _restSeconds = 90;
  String _exerciseType = ExerciseTypes.reps;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialGroup != null) _selectedGroups.add(widget.initialGroup!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _equipmentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Donne un nom à l\'exercice');
      return;
    }
    if (_selectedGroups.isEmpty) {
      _showError('Choisis au moins un groupe musculaire');
      return;
    }
    setState(() => _saving = true);
    await ref.read(exerciseRepositoryProvider).create(
          name: name,
          equipment: _equipmentController.text.trim().isEmpty
              ? 'Autre'
              : _equipmentController.text.trim(),
          description: _descriptionController.text.trim(),
          defaultRestSeconds: _restSeconds,
          muscleSlugs: _selectedGroups.toList(),
          exerciseType: _exerciseType,
        );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('« $name » ajouté à tes exercices')),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [
              const Text(
                'Nouvel exercice',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Nom *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _equipmentController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Équipement',
                  hintText: 'Barre, Haltères, Machine, Poids du corps…',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration:
                    const InputDecoration(labelText: 'Description (optionnel)'),
              ),
              const SizedBox(height: 18),
              const Text(
                'Mesure de la performance',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: ExerciseTypes.reps,
                    icon: Icon(Icons.fitness_center, size: 16),
                    label: Text('Poids × reps'),
                  ),
                  ButtonSegment(
                    value: ExerciseTypes.duration,
                    icon: Icon(Icons.timer_outlined, size: 16),
                    label: Text('Durée (s)'),
                  ),
                ],
                selected: {_exerciseType},
                onSelectionChanged: (selection) =>
                    setState(() => _exerciseType = selection.first),
                showSelectedIcon: false,
              ),
              const SizedBox(height: 18),
              const Text(
                'Groupes musculaires travaillés *',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final group in kMuscleGroups)
                    FilterChip(
                      avatar: Icon(group.icon, size: 16),
                      label: Text(group.label),
                      selected: _selectedGroups.contains(group.slug),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _selectedGroups.add(group.slug);
                        } else {
                          _selectedGroups.remove(group.slug);
                        }
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text(
                    'Repos par défaut',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: () => setState(
                        () => _restSeconds = (_restSeconds - 15).clamp(15, 900)),
                    icon: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      formatTimer(_restSeconds),
                      style: numberStyle(context, size: 22),
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: () => setState(
                        () => _restSeconds = (_restSeconds + 15).clamp(15, 900)),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Créer l\'exercice'),
              ),
            ],
          );
        },
      ),
    );
  }
}
