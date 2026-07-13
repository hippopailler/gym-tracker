import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_service.dart';

/// État du chrono de la séance : repos entre les séries, ou exécution
/// d'un exercice en durée (gainage…) quand [exerciseName] est renseigné.
class RestTimerState {
  const RestTimerState({
    required this.isActive,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.exerciseName,
  });

  const RestTimerState.idle()
      : isActive = false,
        totalSeconds = 0,
        remainingSeconds = 0,
        exerciseName = null;

  final bool isActive;
  final int totalSeconds;
  final int remainingSeconds;

  /// Nom de l'exercice chronométré, ou null pour un repos.
  final String? exerciseName;

  bool get isExercise => exerciseName != null;

  double get progress =>
      totalSeconds == 0 ? 0 : 1 - remainingSeconds / totalSeconds;
}

/// Chrono de repos entre les séries, ou chrono d'exécution d'un exercice
/// en durée.
///
/// Le décompte est basé sur une heure de fin absolue (et non un simple
/// compteur décrémenté) : il reste juste même si l'app passe en arrière-plan.
class RestTimerController extends StateNotifier<RestTimerState> {
  RestTimerController(this._notifications) : super(const RestTimerState.idle());

  final NotificationService _notifications;

  Timer? _ticker;
  DateTime? _startedAt;
  DateTime? _endsAt;
  String? _exerciseName;
  void Function(int elapsedSeconds)? _onComplete;

  /// Lance le chrono pour [seconds] secondes. [onComplete] reçoit le temps
  /// réellement écoulé (fin naturelle ou chrono passé). Avec [exerciseName],
  /// le chrono compte l'exécution d'un exercice en durée plutôt qu'un repos.
  Future<void> start(int seconds,
      {String? exerciseName,
      void Function(int elapsedSeconds)? onComplete}) async {
    _ticker?.cancel();
    _onComplete = onComplete;
    _exerciseName = exerciseName;
    _startedAt = DateTime.now();
    _endsAt = _startedAt!.add(Duration(seconds: seconds));
    state = RestTimerState(
      isActive: true,
      totalSeconds: seconds,
      remainingSeconds: seconds,
      exerciseName: exerciseName,
    );
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    await _scheduleNotification(seconds);
  }

  Future<void> _scheduleNotification(int seconds) {
    final name = _exerciseName;
    return _notifications.scheduleTimerEnd(
      seconds: seconds,
      title: name == null ? 'Repos terminé 💪' : 'Temps écoulé ⏱️',
      body: name == null
          ? 'C\'est reparti, attaque ta prochaine série !'
          : '$name : série terminée, bien joué !',
    );
  }

  void _tick() {
    final endsAt = _endsAt;
    if (endsAt == null) return;
    // Arrondi au plafond : le chrono n'expire qu'à la vraie échéance (sinon
    // une série en durée serait validée ~1 s trop tôt).
    final remainingMs = endsAt.difference(DateTime.now()).inMilliseconds;
    final remaining = (remainingMs / 1000).ceil();
    if (remainingMs <= 0) {
      HapticFeedback.vibrate();
      _finish();
    } else if (remaining != state.remainingSeconds) {
      state = RestTimerState(
        isActive: true,
        totalSeconds: state.totalSeconds,
        remainingSeconds: remaining,
        exerciseName: _exerciseName,
      );
    }
  }

  /// Ajuste le chrono à la volée (+15 s / −15 s).
  Future<void> addSeconds(int delta) async {
    final endsAt = _endsAt;
    if (endsAt == null || !state.isActive) return;
    final newEnd = endsAt.add(Duration(seconds: delta));
    final remaining =
        (newEnd.difference(DateTime.now()).inMilliseconds / 1000).ceil();
    if (remaining <= 0) {
      await skip();
      return;
    }
    _endsAt = newEnd;
    state = RestTimerState(
      isActive: true,
      totalSeconds: (state.totalSeconds + delta).clamp(1, 3600),
      remainingSeconds: remaining,
      exerciseName: _exerciseName,
    );
    await _scheduleNotification(remaining);
  }

  /// Termine le chrono manuellement (repos passé, exercice arrêté plus tôt).
  Future<void> skip() async {
    await _notifications.cancelTimerEnd();
    _finish();
  }

  /// Arrête le chrono sans rappeler [_onComplete] (fin de séance, abandon).
  Future<void> cancel() async {
    await _notifications.cancelTimerEnd();
    _ticker?.cancel();
    _onComplete = null;
    _startedAt = null;
    _endsAt = null;
    _exerciseName = null;
    state = const RestTimerState.idle();
  }

  void _finish() {
    _ticker?.cancel();
    final startedAt = _startedAt;
    final elapsed = startedAt == null
        ? state.totalSeconds
        : (DateTime.now().difference(startedAt).inMilliseconds / 1000)
            .round();
    final callback = _onComplete;
    _onComplete = null;
    _startedAt = null;
    _endsAt = null;
    _exerciseName = null;
    state = const RestTimerState.idle();
    callback?.call(elapsed);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
