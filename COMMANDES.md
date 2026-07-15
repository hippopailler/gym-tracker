# Gym Tracker — Mémo commandes & roadmap

## Avant tout (nouveau terminal)

Les chemins Flutter/Android/Java sont déjà dans `~/.zshrc`. Un nouveau terminal suffit ;
sinon : `source ~/.zshrc`. Vérification rapide : `flutter doctor`.

## Lancer le projet

### Sur l'émulateur

```bash
emulator -avd gym_pixel &        # démarrer l'émulateur (laisser tourner)
cd ~/Desktop/gym
flutter run                      # compile et lance en mode debug
```

Pendant que `flutter run` tourne : `r` = hot reload (modif de code en ~1 s),
`R` = redémarrage complet, `q` = quitter. Éteindre l'émulateur : `adb emu kill`.

### Sur le téléphone (Xiaomi)

Brancher en USB (débogage USB + « Installer via USB » activés), puis :

```bash
cd ~/Desktop/gym
flutter devices                                            # le téléphone doit apparaître
flutter build apk --release                                # compile l'APK signé
adb install -r build/app/outputs/flutter-apk/app-release.apk   # installe / met à jour
```

Les **données sont conservées** à chaque mise à jour (même clé de signature).
⚠️ Ne jamais perdre `android/app/upload-keystore.jks` + `android/key.properties`
(mots de passe dedans) : sans eux, plus de mise à jour possible sans tout désinstaller.
⚠️ Ne jamais supprimer `android/app/proguard-rules.pro` : sans lui, R8 casse les
notifications en release (« Missing type parameter ») et les boutons
Abandonner/Remplacer avec (cf. leçon n° 6 d'AVANCEMENT.md).

### Icône de l'application

Sources dans `assets/icon/`, dessinées par un script. Pour changer le design :

```bash
flutter test tool/generate_icons_test.dart   # régénère les PNG sources
dart run flutter_launcher_icons              # régénère les mipmaps Android
```

## Tests & vérifications

```bash
flutter test                     # les 19 tests (logique, base, migrations, navigation)
flutter analyze                  # analyse statique — doit rester à 0 problème
```

⚠️ Les bugs liés à R8 (notifications) n'apparaissent **qu'en APK release** :
pour les flux critiques (chrono, notifications, fins de séance), vérifier aussi
sur `flutter build apk --release` installé sur l'émulateur ou le téléphone.

## Migrations de base de données

**Quand ?** Uniquement si on modifie le schéma (`lib/data/database/tables.dart`).

La procédure (l'app migre ensuite toute seule au lancement, sans perte de données) :

1. Modifier les tables dans `tables.dart`
2. Incrémenter `schemaVersion` dans `lib/data/database/database.dart`
3. Ajouter l'étape dans `onUpgrade` (s'inspirer de `_migrateToV2`/`_migrateToV3` :
   chaque étape doit être **idempotente** — vérifier l'existence des colonnes/tables avant d'agir)
4. Régénérer le code Drift :
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. Ajouter un test dans `test/migration_test.dart` et lancer `flutter test`

Règle d'or apprise à la dure : `m.alterTable(...)` recrée la table selon le schéma
**courant** — les colonnes des versions ultérieures doivent exister avant la copie.

## Sauvegarde des données (état actuel)

- Tout vit dans un fichier SQLite privé sur l'appareil (`gym_tracker.sqlite`)
- Survit aux mises à jour ; détruit par la désinstallation
- Pas encore d'export → **ne pas désinstaller l'app** sans avoir fait l'export (à développer, cf. roadmap)

---

## Roadmap — idées d'amélioration

### Priorité 1 (protéger les données)
- [ ] **Export / import JSON** : bouton « Exporter mes données » → fichier partageable (Drive, mail) + import au premier lancement. Indispensable avant d'accumuler des mois d'historique
- [ ] **Renommer l'identifiant d'app** (`com.example.gym` → définitif) — à faire EN MÊME TEMPS que l'export/import pour migrer les données du téléphone

### Vite rentables
- [x] Records personnels affichés sur l'accueil et la fiche exercice (tableau des PR) — *fait le 12/07/2026*
- [x] Ajout d'une série/exercice à une séance passée depuis l'éditeur — *fait le 12/07/2026*
- [x] Chrono d'exécution pour les exercices en durée (▶ par série, validation auto) — *fait le 12/07/2026*
- [x] Icône d'application personnalisée (haltère orange, adaptive icon) — *fait le 12/07/2026*
- [x] Notes par exercice pendant la séance (icône 📝 discrète, rappel de la note précédente) — *fait le 13/07/2026*
- [x] Ajouter plusieurs exercices d'un coup (picker multi-sélection, templates + séance) — *fait le 13/07/2026*
- [x] Modifier/supprimer les exercices créés (menu ⋮ dans la liste d'un groupe) — *fait le 13/07/2026*
- [x] Thème de couleurs au choix : orange, violet, vert, bleu (bouton 🎨 sur l'accueil) — *fait le 13/07/2026*
- [x] Exercices street workout (Muscle-up, Pistol squat, Front lever, L-sit…) — *fait le 13/07/2026*
- [x] Exercices cardio durée + distance : Rameur, Skieur, Course — *fait le 13/07/2026*
- [x] Import de l'historique papier (56 séances, 16/03 → 08/07/2026) + templates des séances types — *fait le 13/07/2026*
- [ ] Saisie du RPE par série (la colonne existe déjà en base)
- [ ] Écran de démarrage : reprendre le dernier template utilisé en un tap
- Sur la page d'acceuil affiché les 3 dernières séances et pas juste la dernière.

### Moyen terme
- [ ] **Programme hebdomadaire** : planifier Push lundi / Pull mercredi… l'accueil propose la séance du jour
- [ ] **Stats globales** : volume par groupe musculaire par semaine (équilibre push/pull), régularité, heatmap annuelle
- [ ] Suggestion de deload après stagnation détectée (3 séances sans progression)
- [ ] Minuterie d'échauffement + calcul des barres d'échauffement (% du 1RM)
- [ ] Superset /Biset / circuits dans les templates
- [ ] Graphique de comparaison entre deux exercices
- Proposer des exercices de remplacement si un exercice n'est pas possible

### Long terme
- [ ] Sauvegarde cloud optionnelle (chiffrée)
- [ ] Widget écran d'accueil Android (séance du jour, streak)
- [ ] Publication Play Store (compte développeur 25 $, `flutter build appbundle`, fiche store)
- [ ] Version montre (Wear OS) pour valider les séries sans sortir le téléphone
