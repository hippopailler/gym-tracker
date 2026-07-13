import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym/data/database/database.dart';
import 'package:gym/data/database/seed_data.dart';

/// Reproduit une base au schéma v1 (un seul groupe musculaire par exercice,
/// colonne texte) puis l'ouvre avec le schéma v2 pour vérifier la migration.
void main() {
  test(
      'migration v1 → v2 : groupes multiples, catalogue enrichi, historique conservé',
      () async {
    final executor = NativeDatabase.memory(setup: _createV1Database);
    await _expectMigrated(executor);
  });

  test('migration v1 → v2 : reprend proprement après une interruption',
      () async {
    // État laissé par une migration qui a échoué en cours de route :
    // table d'association et colonne is_custom déjà créées, liens déjà
    // copiés, mais colonne muscle_group pas encore supprimée et
    // user_version toujours à 1.
    final executor = NativeDatabase.memory(setup: (raw) {
      _createV1Database(raw);
      raw.execute('''
        CREATE TABLE "exercise_muscles" (
          "exercise_id" INTEGER NOT NULL REFERENCES "exercises" ("id") ON DELETE CASCADE,
          "muscle_group" TEXT NOT NULL,
          PRIMARY KEY ("exercise_id", "muscle_group")
        );
      ''');
      raw.execute(
          'ALTER TABLE "exercises" ADD COLUMN "is_custom" INTEGER NOT NULL DEFAULT 0');
      raw.execute(
          "INSERT INTO exercise_muscles (exercise_id, muscle_group) VALUES (1, 'dos'), (1, 'biceps'), (2, 'dos')");
    });
    await _expectMigrated(executor);
  });
}

void _createV1Database(dynamic raw) {
  raw.execute('''
        CREATE TABLE "exercises" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "name" TEXT NOT NULL,
          "muscle_group" TEXT NOT NULL,
          "equipment" TEXT NOT NULL,
          "description" TEXT NOT NULL DEFAULT '',
          "default_rest_seconds" INTEGER NOT NULL DEFAULT 90
        );
      ''');
  raw.execute('''
        CREATE TABLE "workout_templates" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "name" TEXT NOT NULL,
          "description" TEXT NOT NULL DEFAULT '',
          "tags" TEXT NOT NULL DEFAULT ''
        );
      ''');
  raw.execute('''
        CREATE TABLE "template_exercises" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "template_id" INTEGER NOT NULL REFERENCES "workout_templates" ("id") ON DELETE CASCADE,
          "exercise_id" INTEGER NOT NULL REFERENCES "exercises" ("id") ON DELETE CASCADE,
          "position" INTEGER NOT NULL,
          "target_sets" INTEGER NOT NULL,
          "target_reps" INTEGER NOT NULL,
          "rest_seconds" INTEGER NOT NULL
        );
      ''');
  raw.execute('''
        CREATE TABLE "workout_sessions" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "date" INTEGER NOT NULL,
          "template_id" INTEGER REFERENCES "workout_templates" ("id") ON DELETE SET NULL,
          "name" TEXT NOT NULL,
          "notes" TEXT NOT NULL DEFAULT '',
          "duration_seconds" INTEGER NOT NULL DEFAULT 0
        );
      ''');
  raw.execute('''
        CREATE TABLE "session_exercises" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "session_id" INTEGER NOT NULL REFERENCES "workout_sessions" ("id") ON DELETE CASCADE,
          "exercise_id" INTEGER NOT NULL REFERENCES "exercises" ("id") ON DELETE CASCADE,
          "position" INTEGER NOT NULL
        );
      ''');
  raw.execute('''
        CREATE TABLE "set_entries" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "session_exercise_id" INTEGER NOT NULL REFERENCES "session_exercises" ("id") ON DELETE CASCADE,
          "set_number" INTEGER NOT NULL,
          "weight_kg" REAL NOT NULL,
          "reps" INTEGER NOT NULL,
          "rpe" REAL,
          "rest_taken_seconds" INTEGER
        );
      ''');
  // Un exercice du catalogue (sera enrichi : dos + biceps) et un exercice
  // inconnu du catalogue (gardera son groupe historique).
  raw.execute(
      "INSERT INTO exercises (name, muscle_group, equipment) VALUES ('Traction', 'Dos', 'Poids du corps')");
  raw.execute(
      "INSERT INTO exercises (name, muscle_group, equipment) VALUES ('Mon exo maison', 'Dos', 'Élastique')");
  // Historique : une séance avec 2 séries de tractions.
  raw.execute(
      "INSERT INTO workout_sessions (date, name, duration_seconds) VALUES (1752000000, 'Pull', 1800)");
  raw.execute(
      'INSERT INTO session_exercises (session_id, exercise_id, position) VALUES (1, 1, 0)');
  raw.execute(
      'INSERT INTO set_entries (session_exercise_id, set_number, weight_kg, reps) VALUES (1, 1, 0, 8)');
  raw.execute(
      'INSERT INTO set_entries (session_exercise_id, set_number, weight_kg, reps) VALUES (1, 2, 0, 6)');
  raw.execute('PRAGMA user_version = 1');
}

Future<void> _expectMigrated(NativeDatabase executor) async {
  final db = AppDatabase.forTesting(executor);
  addTearDown(db.close);

  final exercises = await db.exerciseDao.watchAllWithMuscles().first;

  // Catalogue enrichi : les nouveaux exercices sont ajoutés, les existants
  // ne sont pas dupliqués (Traction déjà présente).
  expect(exercises.length, kSeedExercises.length + 1);

  // L'exercice du catalogue est enrichi avec ses groupes multiples.
  final pullUp = exercises.firstWhere((e) => e.exercise.name == 'Traction');
  expect(pullUp.exercise.id, 1, reason: 'l\'id historique est conservé');
  expect(pullUp.muscleSlugs, containsAll(['dos', 'biceps']));

  // L'exercice inconnu du catalogue garde son groupe historique.
  final custom =
      exercises.firstWhere((e) => e.exercise.name == 'Mon exo maison');
  expect(custom.muscleSlugs, ['dos']);

  // L'historique de performances est intact.
  final lastSets = await db.sessionDao.lastSetsForExercise(1);
  expect(lastSets.length, 2);
  expect(lastSets.map((s) => s.reps), [8, 6]);

  final summaries = await db.sessionDao.watchSummaries().first;
  expect(summaries.single.session.name, 'Pull');
}
