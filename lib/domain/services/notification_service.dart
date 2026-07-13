import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Notifications locales de fin de chrono (repos ou exercice en durée).
///
/// La notification est planifiée dès le lancement du chrono : elle sonne
/// et vibre à l'heure prévue même si l'app est en arrière-plan, puis
/// disparaît d'elle-même au bout d'une minute. Elle est annulée/replanifiée
/// si le chrono est passé ou ajusté.
///
/// Aucun échec de plateforme ne doit remonter à l'appelant : une
/// notification ratée ne doit jamais bloquer le déroulement de la séance
/// (le chrono in-app reste la source de vérité).
class NotificationService {
  static const int _timerNotificationId = 1;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(settings);
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    } on PlatformException {
      // Sans notifications, l'app reste pleinement utilisable.
    }
  }

  static const AndroidNotificationDetails _timerDetails =
      AndroidNotificationDetails(
    'rest_timer',
    'Fin de chrono',
    channelDescription:
        'Alerte de fin du temps de repos ou d\'exercice chronométré',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    category: AndroidNotificationCategory.alarm,
    autoCancel: true,
    // Notification éphémère : elle s'efface seule après une minute.
    timeoutAfter: 60000,
  );

  /// Planifie l'alerte de fin de chrono dans [seconds] secondes.
  Future<void> scheduleTimerEnd({
    required int seconds,
    required String title,
    required String body,
  }) async {
    await cancelTimerEnd();
    if (seconds <= 0) return;
    final when = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: seconds));
    const details = NotificationDetails(android: _timerDetails);
    try {
      await _plugin.zonedSchedule(
        _timerNotificationId,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } on PlatformException {
      // Alarme exacte refusée (Android 14+) : repli sur une alarme inexacte.
      try {
        await _plugin.zonedSchedule(
          _timerNotificationId,
          title,
          body,
          when,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } on PlatformException {
        // Notification impossible : le chrono in-app suffit.
      }
    }
  }

  Future<void> cancelTimerEnd() async {
    try {
      await _plugin.cancel(_timerNotificationId);
    } on PlatformException {
      // Rien à annuler ou plateforme indisponible : sans gravité.
    }
  }
}
