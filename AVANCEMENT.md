# Gym Tracker — Journal d'avancement

> Trace de tout ce qui a été construit, décidé et appris. Dernière mise à jour : **12 juillet 2026**.

## L'application aujourd'hui

App Android de suivi de musculation, 100 % locale (SQLite, aucun backend), en français,
Material 3 sombre par défaut (accent orange) avec thème clair basculable.

**5 onglets** : Accueil · Templates · Exercices · Calendrier · Progression.

### Fonctionnalités livrées

| Domaine | Détail |
|---|---|
| Séance active | Saisie rapide par série (poids × reps **ou** durée en secondes), validation → chrono de repos automatique (grand compteur, −15 s / +15 s / Passer, modifiable par exercice), notification son + vibration même en arrière-plan (alarme exacte + repli inexact), éphémère (s'efface après 1 min) |
| Chrono d'exercice | Pour les exercices en durée : bouton ▶ par série → chrono d'exécution au format de la barre de repos (nom de l'exo affiché, −15 s / +15 s / Valider) ; à la fin (ou validation anticipée) la série est validée automatiquement avec le temps effectué, puis le repos s'enchaîne. Notification dédiée si l'app est en arrière-plan |
| Suggestions | +2,5 kg si l'objectif de reps a été atteint sur toutes les séries la dernière fois, sinon mêmes charges ; +15 s pour les exercices en durée. Valeurs proposées **série par série** (même série de la dernière séance) |
| « Comme la dernière fois » | Bouton ↺ par série : reprend la dernière performance et valide en un tap |
| Records personnels | Détection à la validation (poids max, 1RM Epley, durée max) → bannière 🏆 + vibration. Pas de célébration sans historique préalable |
| Persistance de séance | Chaque mutation sauvegarde un instantané JSON en base (`active_session_drafts`) ; séance restaurée au relancement de l'app |
| Templates | 5 par défaut (Push, Pull, Legs, Épaules, Full body débutant), création/édition/duplication/suppression, réordonnancement par glisser-déposer, cibles séries/reps(ou s)/repos par exercice |
| Exercices | Catalogue de 32 exercices, **multi-groupes musculaires** (n-n), 10 groupes avec icônes, ajout d'exercices perso (multi-groupes, type poids×reps ou durée, badge « perso », suppression avec avertissement) |
| Calendrier | Vue mensuelle FR avec marqueurs, résumé du jour, vue liste chronologique, détail complet de séance en bottom sheet |
| Édition d'historique | ✏️ corriger une séance passée (nom, notes, valeurs des séries, supprimer séries/exercices, **ajouter des séries et des exercices oubliés**) · 🗑️ supprimer une séance |
| Records personnels | Carte « 🏆 Tes records » sur l'accueil (1-2 PR, rotation quotidienne déterministe, jamais surchargée) · fiche exercice (tap dans la liste d'un groupe) avec tableau des PR datés : poids max × reps, 1RM estimé, volume record, durée max, nb de séances |
| Icône | Icône haltère orange sur fond sombre (adaptive icon + monochrome Android 13), générée par `tool/generate_icons_test.dart` + flutter_launcher_icons |
| Progression | Sélecteur groupé par muscle (chips + dropdown), graphique fl_chart : poids max / volume / 1RM estimé — ou durée max / durée totale pour les exercices en durée. Tuiles record / 1RM / dernier volume |

### Architecture (lib/)

- `core/` — thème, formats FR, router (StatefulShellRoute 5 onglets + routes plein écran `/session`, `/history/edit/:id`), providers Riverpod centraux
- `tool/generate_icons_test.dart` — générateur des sources d'icône (assets/icon/), puis `dart run flutter_launcher_icons`
- `data/database/` — `tables.dart` (8 tables), `database.dart` (migrations + seed), `seed_data.dart` (catalogue + templates), 3 DAOs
- `data/repositories/` — exercise / template / session
- `domain/models/` — ExerciseDetail, TemplateWithExercises, SessionDetail/Summary, ActiveSessionState (JSON-sérialisable), PersonalBests, muscle_groups (catalogue slugs+icônes)
- `domain/services/` — ProgressionService (suggestions, Epley, volume), RestTimerController (basé heure de fin absolue), NotificationService
- `features/` — home, templates, exercises, session, calendar (+ session_edit_screen), progress
- `widgets/` — set_row, rest_timer_bar, exercise_picker_sheet, stat_tile, empty_state

### Base de données — schéma v3

Tables : `exercises` (+ `is_custom`, `exercise_type` reps|duration), `exercise_muscles` (n-n, PK composite),
`workout_templates`, `template_exercises`, `workout_sessions`, `session_exercises`,
`set_entries` (+ `duration_seconds`), `active_session_drafts` (1 ligne JSON).
FK avec `ON DELETE CASCADE` partout où pertinent. Fichier : `app_flutter/gym_tracker.sqlite`.

Historique des migrations (toutes **idempotentes**, testées) :
- **v1 → v2** : `muscle_group` (colonne unique) → table n-n `exercise_muscles`, catalogue 10 → 32 exercices, ids historiques conservés
- **v2 → v3** : `exercise_type`, `duration_seconds`, `active_session_drafts`, Planche convertie en durée

## Leçons apprises (pièges à ne pas re-payer)

1. **drift_dev 2.31 + analyzer 10** : les `references()` étaient silencieusement ignorés (avertissement « simple class name ») → **drift ≥ 2.34 requis** ; vérifier `REFERENCES` dans le `.g.dart` après codegen.
2. **Les migrations drift ne sont PAS transactionnelles de bout en bout** : une migration qui échoue laisse un état partiel. → Chaque étape vérifie l'état réel (`pragma_table_info`, `CREATE TABLE IF NOT EXISTS`, `insertOrIgnore`).
3. **`m.alterTable(TableMigration(...))` recrée la table selon le schéma COURANT** (pas celui de l'étape) : toutes les colonnes des versions ultérieures doivent exister avant la copie (cf. `_migrateToV2` qui crée `exercise_type`).
4. **flutter_local_notifications** exige le desugaring (`build.gradle.kts`) + receivers dans le manifest ; alarme exacte → `SCHEDULE_EXACT_ALARM`/`USE_EXACT_ALARM` + repli `inexactAllowWhileIdle` en catch.
5. **Xiaomi/HyperOS** : installation USB bloquée par défaut → activer « Installer via USB » dans les options développeur ; économie de batterie agressive → mettre l'app en « Aucune restriction » pour la fiabilité du chrono.
6. **R8 casse flutter_local_notifications en release** : le plugin Gradle de Flutter active la minification par défaut en release, et flutter_local_notifications 17 (GSON 2.8.9) ne fournit pas de règles consumer → dès qu'une notification a été planifiée, `zonedSchedule()`/`cancel()` plantent avec `PlatformException(Missing type parameter)`. Symptômes vécus : boutons « Abandonner » et « Remplacer » inopérants (l'annulation de la notification échouait avant la navigation), notifications de repos jamais délivrées — **uniquement en APK release**, debug parfait. Correctif : `android/app/proguard-rules.pro` (ne jamais le supprimer) + try/catch dans `NotificationService` pour qu'un échec de notification ne bloque jamais la séance. Moralité : **tester les flux critiques en build release**, pas seulement en debug.

## Environnement & outillage (ce Mac)

- **Flutter 3.44.6 stable** : `~/development/flutter` · **JDK 17 Temurin** : `~/development/jdk-17`
- **Android SDK** : `~/Library/Android/sdk` (platform-tools, build-tools 36, platforms 35/36, émulateur)
- **AVD** : `gym_pixel` (Pixel 7, Android 36, arm64)
- PATH/JAVA_HOME/ANDROID_HOME configurés dans `~/.zshrc`
- `flutter doctor` : ✓ Android toolchain

## Téléphone

- **Xiaomi (2412DPC0AG), Android 16** : APK release installé le 12/07/2026 —
  ⚠️ cet APK a le bug R8 des notifications (leçon n° 6) : **réinstaller le build
  corrigé** (`flutter build apk --release` puis `adb install -r …`)
- Pour des alarmes de fin de repos exactes : autoriser « Alarmes et rappels »
  pour l'app dans les paramètres Android (sinon repli inexact, ~1 min de retard)
- **Clé de signature release** : `android/app/upload-keystore.jks` + mots de passe dans `android/key.properties`
  (exclus de git) — **à sauvegarder en lieu sûr, irremplaçable**
- ⚠️ Identifiant d'app encore `com.example.gym` → à renommer définitivement **avant** d'accumuler
  un vrai historique (le changer = nouvelle app = données à re-migrer)

## Qualité

- `flutter analyze` : 0 problème · **19 tests verts** :
  - progression (suggestions reps + durée, Epley, volume)
  - base de données (seed, CRUD templates, séances, records, brouillon actif, corrections/suppressions/**ajouts** sur séance passée, records datés + vue d'ensemble, exercice en durée)
  - **migrations** (v1 → v3 complet + reprise après migration interrompue)
  - **navigation** (test widget : abandon de séance vide, remplacement de séance en cours)
- Toujours relancer `dart run build_runner build --delete-conflicting-outputs` après modification de `tables.dart`
- Piège des tests widget avec drift : à la fin du test, démonter l'app (`pumpWidget(SizedBox)` + `pump()`) pour laisser drift fermer ses streams, sinon « A Timer is still pending » aléatoire

## Prochaines étapes envisagées

Voir la roadmap détaillée dans [COMMANDES.md](COMMANDES.md). Priorité recommandée :
**export/import JSON + renommage de l'identifiant d'app** (à faire ensemble, avant accumulation d'historique).
