import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/formats.dart';
import '../core/theme.dart';
import '../domain/models/active_session.dart';

/// Saisie rapide d'une série pendant la séance : poids × répétitions, ou
/// durée en secondes selon le type d'exercice. Le bouton « ↺ » reprend la
/// dernière performance en un tap. Une série validée s'affiche verrouillée
/// et peut être rouverte d'un tap. Pour les exercices en durée, le bouton
/// « ▶ » lance le chrono d'exécution (la série se valide à la fin).
class SetRow extends StatefulWidget {
  const SetRow({
    super.key,
    required this.setNumber,
    required this.set,
    required this.isDuration,
    required this.weightHint,
    required this.repsHint,
    required this.durationHint,
    required this.lastPerformance,
    required this.onValidate,
    required this.onReopen,
    this.onStartTimer,
  });

  final int setNumber;
  final ActiveSet set;
  final bool isDuration;
  final double? weightHint;
  final int? repsHint;
  final int? durationHint;

  /// Performance de la même série lors de la dernière séance — alimente le
  /// bouton « comme la dernière fois ».
  final LastSetData? lastPerformance;

  final void Function(double weightKg, int reps, int? durationSeconds)
      onValidate;
  final VoidCallback onReopen;

  /// Lance le chrono d'exécution pour un exercice en durée (secondes de la
  /// saisie, sinon valeur proposée). Absent pour les exercices poids × reps.
  final void Function(int seconds)? onStartTimer;

  @override
  State<SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<SetRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.set.weightKg == null || widget.set.weightKg == 0
          ? ''
          : _trimNumber(widget.set.weightKg!),
    );
    _repsController = TextEditingController(
      text: (widget.set.reps ?? 0) == 0 ? '' : widget.set.reps.toString(),
    );
    _durationController = TextEditingController(
      text: widget.set.durationSeconds?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String _trimNumber(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString().replaceAll('.', ',');
  }

  double? _parseWeight() =>
      double.tryParse(_weightController.text.trim().replaceAll(',', '.'));

  int? _parseReps() => int.tryParse(_repsController.text.trim());

  int? _parseDuration() => int.tryParse(_durationController.text.trim());

  void _validate() {
    if (widget.isDuration) {
      final duration = _parseDuration();
      if (duration == null || duration <= 0) {
        _showError('Saisis une durée en secondes');
        return;
      }
      FocusScope.of(context).unfocus();
      widget.onValidate(0, 0, duration);
      return;
    }
    final weight = _parseWeight();
    final reps = _parseReps();
    if (weight == null || reps == null || reps <= 0 || weight < 0) {
      _showError('Saisis un poids et des répétitions valides');
      return;
    }
    FocusScope.of(context).unfocus();
    widget.onValidate(weight, reps, null);
  }

  /// Reprend la dernière performance (même série de la dernière séance,
  /// sinon valeurs suggérées) et valide directement.
  void _repeatLast() {
    final last = widget.lastPerformance;
    if (widget.isDuration) {
      final duration = last?.durationSeconds ?? widget.durationHint;
      if (duration == null || duration <= 0) return;
      FocusScope.of(context).unfocus();
      widget.onValidate(0, 0, duration);
      return;
    }
    final weight = last?.weightKg ?? widget.weightHint;
    final reps = last?.reps ?? widget.repsHint;
    if (weight == null || reps == null || reps <= 0) return;
    FocusScope.of(context).unfocus();
    widget.onValidate(weight, reps, null);
  }

  bool get _canRepeatLast {
    final last = widget.lastPerformance;
    if (widget.isDuration) {
      return (last?.durationSeconds ?? widget.durationHint ?? 0) > 0;
    }
    return (last?.weightKg ?? widget.weightHint) != null &&
        (last?.reps ?? widget.repsHint ?? 0) > 0;
  }

  /// Lance le chrono d'exécution avec la durée saisie, sinon la proposée.
  void _startTimer() {
    final duration = _parseDuration() ?? widget.durationHint;
    if (duration == null || duration <= 0) {
      _showError('Saisis une durée en secondes');
      return;
    }
    FocusScope.of(context).unfocus();
    widget.onStartTimer!(duration);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (widget.set.isDone) {
      return InkWell(
        onTap: widget.onReopen,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _SetBadge(number: widget.setNumber, done: true),
              const SizedBox(width: 12),
              if (widget.isDuration) ...[
                Text(
                  formatTimer(widget.set.durationSeconds ?? 0),
                  style: numberStyle(context, size: 18),
                ),
                const SizedBox(width: 4),
                Text('min:s',
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 13)),
              ] else ...[
                Text(
                  formatKg(widget.set.weightKg ?? 0),
                  style: numberStyle(context, size: 18),
                ),
                const SizedBox(width: 6),
                Text('×', style: TextStyle(color: scheme.onSurfaceVariant)),
                const SizedBox(width: 6),
                Text('${widget.set.reps}',
                    style: numberStyle(context, size: 18)),
                const SizedBox(width: 4),
                Text('reps',
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 13)),
              ],
              const Spacer(),
              Icon(Icons.check_circle, color: scheme.primary, size: 24),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          _SetBadge(number: widget.setNumber, done: false),
          const SizedBox(width: 12),
          if (widget.isDuration)
            Expanded(
              child: TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style:
                    numberStyle(context, size: 16, weight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: widget.durationHint?.toString() ?? 'secondes',
                  suffixText: 's',
                  isDense: true,
                ),
              ),
            )
          else ...[
            Expanded(
              flex: 3,
              child: TextField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
                textAlign: TextAlign.center,
                style:
                    numberStyle(context, size: 16, weight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: widget.weightHint == null
                      ? 'kg'
                      : _trimNumber(widget.weightHint!),
                  suffixText: 'kg',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style:
                    numberStyle(context, size: 16, weight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: widget.repsHint?.toString() ?? 'reps',
                  isDense: true,
                ),
              ),
            ),
          ],
          const SizedBox(width: 6),
          if (_canRepeatLast)
            IconButton.outlined(
              onPressed: _repeatLast,
              icon: const Icon(Icons.replay, size: 20),
              tooltip: 'Comme la dernière fois',
              visualDensity: VisualDensity.compact,
            ),
          if (widget.isDuration && widget.onStartTimer != null) ...[
            const SizedBox(width: 2),
            IconButton.filledTonal(
              onPressed: _startTimer,
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Lancer le chrono',
              visualDensity: VisualDensity.compact,
            ),
          ],
          const SizedBox(width: 2),
          IconButton.filled(
            onPressed: _validate,
            icon: const Icon(Icons.check),
            tooltip: 'Valider la série',
          ),
        ],
      ),
    );
  }
}

class _SetBadge extends StatelessWidget {
  const _SetBadge({required this.number, required this.done});

  final int number;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? scheme.primary
            : scheme.onSurface.withValues(alpha: 0.08),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: done ? scheme.onPrimary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
