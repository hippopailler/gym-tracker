import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:gym/app.dart';
import 'package:gym/core/providers.dart';
import 'package:gym/core/router.dart';
import 'package:gym/data/database/database.dart';
import 'package:gym/domain/services/notification_service.dart';
import 'package:gym/features/home/home_screen.dart';
import 'package:gym/features/session/active_session_screen.dart';

/// Service de notifications neutralisé pour les tests widget (pas de canal
/// de plateforme disponible).
class FakeNotificationService extends NotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleTimerEnd({
    required int seconds,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelTimerEnd() async {}
}

/// Pompe jusqu'à l'apparition de [finder] (l'écran de séance a un ticker
/// périodique : `pumpAndSettle` ne convergerait jamais).
Future<void> pumpUntilFound(WidgetTester tester, Finder finder,
    {int maxTries = 100}) async {
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Widget introuvable après ${maxTries * 100} ms : $finder');
}

/// Pompe jusqu'à la disparition de [finder] (fin d'animation de route).
Future<void> pumpUntilGone(WidgetTester tester, Finder finder,
    {int maxTries = 100}) async {
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isEmpty) return;
  }
  fail('Widget toujours présent après ${maxTries * 100} ms : $finder');
}

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'fr_FR';
    await initializeDateFormatting('fr_FR');
  });

  testWidgets(
      'abandonner une séance sans série validée ramène à l\'accueil, '
      'et « Remplacer » depuis l\'accueil démarre bien la nouvelle séance',
      (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          notificationServiceProvider.overrideWithValue(
            FakeNotificationService(),
          ),
        ],
        child: const GymApp(),
      ),
    );
    await pumpUntilFound(tester, find.text('Démarrer'));

    // --- Démarrage d'une première séance depuis un template ---
    await tester.tap(find.text('Démarrer').first);
    await pumpUntilFound(tester, find.text('Terminer'));

    // --- Bug rapporté n°1 : « Abandonner » dans « Aucune série validée » ---
    await tester.tap(find.text('Terminer'));
    await pumpUntilFound(tester, find.text('Aucune série validée'));

    await tester.tap(find.text('Abandonner'));
    await pumpUntilGone(tester, find.byType(ActiveSessionScreen));
    expect(find.byType(HomeScreen), findsOneWidget,
        reason: 'après abandon on doit revenir à l\'accueil');
    expect(find.text('SÉANCE EN COURS'), findsNothing);

    // --- Nouvelle séance, retour à l'accueil sans la terminer ---
    await tester.tap(find.text('Démarrer').first);
    await pumpUntilFound(tester, find.text('Terminer'));
    // Retour accueil via le bouton « fermer » du dialogue plein écran.
    await tester.tap(find.byType(CloseButton));
    await pumpUntilFound(tester, find.text('SÉANCE EN COURS'));

    // --- Bug rapporté n°2 : « Remplacer » depuis l'accueil ---
    await tester.ensureVisible(find.text('Démarrer').at(1));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Démarrer').at(1), warnIfMissed: false);
    await pumpUntilFound(tester, find.text('Remplacer'));

    await tester.tap(find.text('Remplacer'));
    await pumpUntilFound(tester, find.text('Terminer'));
    expect(find.byType(ActiveSessionScreen), findsOneWidget,
        reason: 'après « Remplacer », la nouvelle séance doit être ouverte');

    // On referme proprement la séance pour ne laisser aucun timer actif.
    await tester.tap(find.text('Terminer'));
    await pumpUntilFound(tester, find.text('Abandonner'));
    await tester.tap(find.text('Abandonner'));
    await pumpUntilGone(tester, find.byType(ActiveSessionScreen));
    expect(appRouter.routerDelegate.currentConfiguration.uri.toString(),
        '/home');
    expect(find.byType(HomeScreen), findsOneWidget);

    // Démonte l'app dans le test : en fermant ses streams, drift planifie
    // un Timer(0) (StreamQueryStore.markAsClosed) que l'on laisse se
    // déclencher avant la vérification « aucun timer en attente ».
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
  });
}
