# Gym Tracker

App Android Flutter de suivi de musculation, 100 % locale (Drift/SQLite), UI en français.

**Avant de travailler ici, lire :**
- [AVANCEMENT.md](AVANCEMENT.md) — tout ce qui est construit, le schéma v3, les leçons apprises (pièges drift/migrations), l'état du téléphone et de l'outillage
- [COMMANDES.md](COMMANDES.md) — commandes de lancement/test/build, procédure de migration DB, roadmap priorisée

## Règles du projet

- Stack : Flutter stable, Riverpod 2 (StateNotifier, pas de codegen riverpod), Drift ≥ 2.34, go_router, fl_chart, table_calendar, flutter_local_notifications 17
- Après toute modification de `lib/data/database/tables.dart` : `dart run build_runner build --delete-conflicting-outputs`, bump `schemaVersion`, étape `onUpgrade` **idempotente**, test dans `test/migration_test.dart`
- `flutter analyze` doit rester à 0 problème ; `flutter test` doit rester vert (16 tests)
- UI en français, thème sombre par défaut (accent orange), chiffres de perf en `numberStyle()` (tabular figures)
- Ne jamais versionner ni régénérer `android/app/upload-keystore.jks` / `android/key.properties` (clé de signature release de l'utilisateur)
- Outillage local : Flutter dans `~/development/flutter`, JDK 17 dans `~/development/jdk-17`, SDK Android dans `~/Library/Android/sdk`, AVD `gym_pixel` — tout est dans le PATH via `~/.zshrc`
