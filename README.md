# Gym Tracker 🏋️

Application Android de suivi de musculation : templates de séances, enregistrement
des performances (poids / répétitions / séries), chrono de récupération avec
notification, calendrier d'historique et graphiques de progression.

100 % locale : aucune API externe, aucune donnée ne quitte le téléphone
(base SQLite via Drift).

## Fonctionnalités

- **Accueil** — séance en cours, stats de la semaine, démarrage rapide depuis un
  template ou en séance libre.
- **Séance active** — saisie rapide par série, suggestion de progression calculée
  sur la dernière performance (+2,5 kg si toutes les séries ont atteint l'objectif,
  sinon mêmes charges), chrono de repos automatique après chaque série validée
  (grand compteur, −15 s / +15 s / passer, modifiable par exercice), notification
  sonore/vibrante à la fin du repos même en arrière-plan.
- **Templates** — 5 templates par défaut (Push, Pull, Legs, Épaules, Full body
  débutant), création / édition / duplication / suppression, réordonnancement des
  exercices, séries / reps / repos cibles par exercice.
- **Calendrier** — vue mensuelle avec marqueurs sur les jours d'entraînement,
  détail des séances du jour sélectionné, vue liste chronologique alternative.
- **Progression** — par exercice : évolution du poids max, du volume total et du
  1RM estimé (formule d'Epley : poids × (1 + reps / 30)).

La base est pré-remplie avec 10 exercices courants (développé couché, squat,
soulevé de terre, développé militaire, rowing, traction, curl biceps, extension
triceps, élévations latérales, presse à cuisses).

## Prérequis

- [Flutter](https://docs.flutter.dev/get-started/install) (stable, ≥ 3.44) —
  `flutter doctor` doit être vert pour la partie Android
- Android SDK (via [Android Studio](https://developer.android.com/studio) ou
  `sdkmanager`) et un appareil Android (API 21+) ou un émulateur

## Lancer le projet

```bash
flutter pub get
flutter run
```

C'est tout. Branchez un téléphone Android (mode développeur + débogage USB activés)
ou démarrez un émulateur au préalable ; `flutter devices` liste les cibles
disponibles, et `flutter run -d <id>` permet d'en choisir une.

> Le code généré par Drift (`*.g.dart`) est versionné avec le projet, donc aucune
> étape de génération n'est nécessaire. Si vous modifiez le schéma de la base
> (`lib/data/database/tables.dart`), relancez :
> `dart run build_runner build --delete-conflicting-outputs`

Au premier lancement, l'app demande la permission de notification (Android 13+) :
acceptez-la pour recevoir l'alerte de fin de repos.

## Tests

```bash
flutter test
```

Couvre la logique de progression (suggestions, Epley, volume) et la couche base
de données (seed, CRUD des templates, sauvegarde et relecture des séances) sur
une base SQLite en mémoire.

## Architecture

```
lib/
  main.dart / app.dart      Bootstrap (locale FR, notifications, Riverpod)
  core/                     Thème M3 (sombre par défaut), formats FR, router, providers
  data/
    database/               Schéma Drift (6 tables), seed, DAOs
    repositories/           Façades exercices / templates / séances
  domain/
    models/                 Modèles composites + état de la séance active
    services/               Progression (+2,5 kg, Epley, volume), chrono de repos,
                            notifications
  features/
    home/                   Écran du jour
    templates/              Liste + éditeur de templates
    session/                Séance active + chrono
    calendar/               Calendrier + historique + détail de séance
    progress/               Graphiques de progression
  widgets/                  set_row, rest_timer_bar, stat_tile, sélecteur d'exercice…
```

- **État** : Riverpod (`StateNotifier` pour la séance active et le chrono,
  `StreamProvider` branchés sur les requêtes réactives de Drift).
- **Persistance** : Drift/SQLite avec clés étrangères `ON DELETE CASCADE`.
- **Navigation** : go_router avec `StatefulShellRoute` (4 onglets) et route
  plein écran pour la séance active.
- **Notifications** : `flutter_local_notifications` — l'alerte est planifiée en
  alarme exacte dès le lancement du chrono (avec repli en alarme inexacte si la
  permission est refusée sur Android 14+), et annulée/replanifiée si le chrono
  est passé ou ajusté.
