import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../data/database/database.dart';
import '../../data/database/tables.dart';
import '../../domain/models/session_models.dart';
import '../../widgets/exercise_picker_sheet.dart';

/// Correction d'une séance passée : nom, notes, valeurs des séries,
/// suppression de séries ou d'exercices entiers, ajout de séries et
/// d'exercices oubliés.
class SessionEditScreen extends ConsumerStatefulWidget {
  const SessionEditScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  ConsumerState<SessionEditScreen> createState() => _SessionEditScreenState();
}

class _EditableSet {
  _EditableSet(SetEntry entry)
      : setId = entry.id,
        weightController = TextEditingController(
            text: entry.weightKg == 0 ? '0' : _trim(entry.weightKg)),
        repsController = TextEditingController(text: '${entry.reps}'),
        durationController =
            TextEditingController(text: '${entry.durationSeconds ?? 0}');

  /// Série ajoutée depuis l'éditeur (pas encore en base), pré-remplie avec
  /// les valeurs de la série précédente le cas échéant.
  _EditableSet.blank({_EditableSet? previous})
      : setId = null,
        weightController =
            TextEditingController(text: previous?.weightController.text ?? ''),
        repsController =
            TextEditingController(text: previous?.repsController.text ?? ''),
        durationController = TextEditingController(
            text: previous?.durationController.text ?? '');

  /// Null tant que la série n'a pas été enregistrée en base.
  final int? setId;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final TextEditingController durationController;

  static String _trim(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString().replaceAll('.', ',');

  void dispose() {
    weightController.dispose();
    repsController.dispose();
    durationController.dispose();
  }
}

class _EditableExercise {
  _EditableExercise(SessionExerciseDetail detail)
      : sessionExerciseId = detail.sessionExerciseId,
        exercise = detail.exercise,
        sets = detail.sets.map(_EditableSet.new).toList();

  /// Exercice ajouté depuis l'éditeur (pas encore en base).
  _EditableExercise.added(this.exercise)
      : sessionExerciseId = null,
        sets = [_EditableSet.blank()];

  /// Null tant que l'exercice n'a pas été enregistré en base.
  final int? sessionExerciseId;
  final Exercise exercise;
  final List<_EditableSet> sets;
}

class _SessionEditScreenState extends ConsumerState<SessionEditScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final List<_EditableExercise> _exercises = [];
  final List<int> _deletedSetIds = [];
  final List<int> _deletedSessionExerciseIds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final detail = await ref
        .read(sessionRepositoryProvider)
        .getDetail(widget.sessionId);
    if (detail != null && mounted) {
      _nameController.text = detail.session.name;
      _notesController.text = detail.session.notes;
      _exercises.addAll(detail.exercises.map(_EditableExercise.new));
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    for (final exercise in _exercises) {
      for (final set in exercise.sets) {
        set.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _save() async {
    final corrections = <SetCorrection>[];
    final addedSets = <NewSetForExercise>[];
    final addedExercises = <CompletedExerciseDraft>[];
    for (final exercise in _exercises) {
      final isDuration =
          exercise.exercise.exerciseType == ExerciseTypes.duration;
      final newExerciseSets = <CompletedSetDraft>[];
      for (final set in exercise.sets) {
        final weight = double.tryParse(
            set.weightController.text.trim().replaceAll(',', '.'));
        final reps = int.tryParse(set.repsController.text.trim());
        final duration = int.tryParse(set.durationController.text.trim());
        if (isDuration) {
          if (duration == null || duration <= 0) {
            _showError(
                'Durée invalide pour « ${exercise.exercise.name} »');
            return;
          }
        } else if (weight == null || reps == null || reps <= 0) {
          _showError(
              'Valeurs invalides pour « ${exercise.exercise.name} »');
          return;
        }
        final setId = set.setId;
        if (setId != null) {
          corrections.add(SetCorrection(
            setId: setId,
            weightKg: weight ?? 0,
            reps: reps ?? 0,
            durationSeconds: isDuration ? duration : null,
          ));
        } else if (exercise.sessionExerciseId != null) {
          addedSets.add(NewSetForExercise(
            sessionExerciseId: exercise.sessionExerciseId!,
            weightKg: weight ?? 0,
            reps: reps ?? 0,
            durationSeconds: isDuration ? duration : null,
          ));
        } else {
          newExerciseSets.add(CompletedSetDraft(
            weightKg: weight ?? 0,
            reps: reps ?? 0,
            durationSeconds: isDuration ? duration : null,
          ));
        }
      }
      if (exercise.sessionExerciseId == null && newExerciseSets.isNotEmpty) {
        addedExercises.add(CompletedExerciseDraft(
          exerciseId: exercise.exercise.id,
          sets: newExerciseSets,
        ));
      }
    }
    await ref.read(sessionRepositoryProvider).applySessionCorrections(
          sessionId: widget.sessionId,
          name: _nameController.text.trim().isEmpty
              ? 'Séance'
              : _nameController.text.trim(),
          notes: _notesController.text.trim(),
          setCorrections: corrections,
          deletedSetIds: _deletedSetIds,
          deletedSessionExerciseIds: _deletedSessionExerciseIds,
          addedSets: addedSets,
          addedExercises: addedExercises,
        );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Séance corrigée ✅')),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeSet(_EditableExercise exercise, int setIndex) {
    setState(() {
      final set = exercise.sets.removeAt(setIndex);
      if (set.setId != null) _deletedSetIds.add(set.setId!);
      set.dispose();
      if (exercise.sets.isEmpty) {
        _exercises.remove(exercise);
        if (exercise.sessionExerciseId != null) {
          _deletedSessionExerciseIds.add(exercise.sessionExerciseId!);
        }
      }
    });
  }

  void _removeExercise(_EditableExercise exercise) {
    setState(() {
      _exercises.remove(exercise);
      if (exercise.sessionExerciseId != null) {
        _deletedSessionExerciseIds.add(exercise.sessionExerciseId!);
      }
      for (final set in exercise.sets) {
        if (set.setId != null) _deletedSetIds.add(set.setId!);
        set.dispose();
      }
    });
  }

  /// Ajoute une série à un exercice, pré-remplie avec la précédente.
  void _addSet(_EditableExercise exercise) {
    setState(() {
      exercise.sets.add(_EditableSet.blank(
          previous: exercise.sets.isEmpty ? null : exercise.sets.last));
    });
  }

  /// Ajoute un exercice oublié à la séance (une série vide à compléter).
  Future<void> _addExercise() async {
    final detail = await showExercisePicker(context);
    if (detail == null || !mounted) return;
    if (_exercises.any((e) => e.exercise.id == detail.exercise.id)) {
      _showError('« ${detail.exercise.name} » est déjà dans la séance');
      return;
    }
    setState(() => _exercises.add(_EditableExercise.added(detail.exercise)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Corriger la séance'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _loading ? null : _save,
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
                  controller: _notesController,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 16),
                for (final exercise in _exercises)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  exercise.exercise.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Retirer l\'exercice',
                                onPressed: () => _removeExercise(exercise),
                              ),
                            ],
                          ),
                          for (var s = 0; s < exercise.sets.length; s++)
                            _buildSetRow(exercise, s, scheme),
                          TextButton.icon(
                            onPressed: () => _addSet(exercise),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Ajouter une série'),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _addExercise,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un exercice'),
                ),
              ],
            ),
    );
  }

  Widget _buildSetRow(
      _EditableExercise exercise, int setIndex, ColorScheme scheme) {
    final set = exercise.sets[setIndex];
    final isDuration =
        exercise.exercise.exerciseType == ExerciseTypes.duration;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '${setIndex + 1}.',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isDuration)
            Expanded(
              child: TextField(
                controller: set.durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style:
                    numberStyle(context, size: 15, weight: FontWeight.w700),
                decoration:
                    const InputDecoration(suffixText: 's', isDense: true),
              ),
            )
          else ...[
            Expanded(
              flex: 3,
              child: TextField(
                controller: set.weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
                textAlign: TextAlign.center,
                style:
                    numberStyle(context, size: 15, weight: FontWeight.w700),
                decoration:
                    const InputDecoration(suffixText: 'kg', isDense: true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: set.repsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style:
                    numberStyle(context, size: 15, weight: FontWeight.w700),
                decoration:
                    const InputDecoration(suffixText: 'reps', isDense: true),
              ),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Supprimer la série',
            onPressed: () => _removeSet(exercise, setIndex),
          ),
        ],
      ),
    );
  }
}
