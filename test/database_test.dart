import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym/data/database/database.dart';
import 'package:gym/data/database/seed_data.dart';
import 'package:gym/domain/models/session_models.dart';
import 'package:gym/domain/models/template_models.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('la base est pré-remplie avec le catalogue et les templates par défaut',
      () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    expect(exercises.length, kSeedExercises.length);
    final names = exercises.map((e) => e.exercise.name);
    expect(names, contains('Développé couché'));
    expect(names, contains('Hip thrust'));

    // Un exercice peut appartenir à plusieurs groupes musculaires.
    final pullUp =
        exercises.firstWhere((e) => e.exercise.name == 'Traction');
    expect(pullUp.muscleSlugs, containsAll(['dos', 'biceps']));
    final deadlift =
        exercises.firstWhere((e) => e.exercise.name == 'Soulevé de terre');
    expect(deadlift.muscleSlugs, containsAll(['dos', 'jambes', 'fessiers']));

    final templates = await db.templateDao.watchAllWithExercises().first;
    expect(templates.length, kSeedTemplates.length);
    final fullBody = templates
        .firstWhere((t) => t.template.name == 'Full body débutant');
    expect(fullBody.exercises.length, 5);
    // L'ordre des exercices est respecté.
    expect(fullBody.exercises.first.exercise.exercise.name, 'Squat');
  });

  test('création et suppression d\'un exercice personnalisé', () async {
    final id = await db.exerciseDao.createExercise(
      name: 'Gainage latéral',
      equipment: 'Poids du corps',
      defaultRestSeconds: 60,
      muscleSlugs: ['abdominaux', 'epaules'],
    );
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final custom =
        exercises.firstWhere((e) => e.exercise.id == id);
    expect(custom.exercise.isCustom, isTrue);
    expect(custom.muscleSlugs, containsAll(['abdominaux', 'epaules']));

    await db.exerciseDao.deleteExercise(id);
    final after = await db.exerciseDao.watchAllWithMuscles().first;
    expect(after.any((e) => e.exercise.id == id), isFalse);
    expect(after.length, kSeedExercises.length);
  });

  test('création, duplication et suppression de template', () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final id = await db.templateDao.saveTemplate(
      name: 'Ma séance',
      description: 'Test',
      tags: 'test',
      items: [
        TemplateExerciseDraft(
          exerciseId: exercises.first.exercise.id,
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
      ],
    );
    final saved = await db.templateDao.getWithExercises(id);
    expect(saved!.template.name, 'Ma séance');
    expect(saved.exercises.length, 1);

    final copyId = await db.templateDao.duplicateTemplate(id);
    final copy = await db.templateDao.getWithExercises(copyId!);
    expect(copy!.template.name, 'Ma séance (copie)');
    expect(copy.exercises.length, 1);

    await db.templateDao.deleteTemplate(id);
    expect(await db.templateDao.getWithExercises(id), isNull);
    // La suppression en cascade ne touche pas la copie.
    expect(await db.templateDao.getWithExercises(copyId), isNotNull);
  });

  test('sauvegarde d\'une séance et dernière performance', () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final bench = exercises
        .firstWhere((e) => e.exercise.name == 'Développé couché')
        .exercise;

    final sessionId = await db.sessionDao.saveCompletedSession(
      CompletedSessionDraft(
        date: DateTime(2026, 7, 10, 18, 30),
        templateId: null,
        name: 'Push',
        notes: 'RAS',
        durationSeconds: 3600,
        exercises: [
          CompletedExerciseDraft(
            exerciseId: bench.id,
            sets: const [
              CompletedSetDraft(weightKg: 60, reps: 8, restTakenSeconds: 120),
              CompletedSetDraft(weightKg: 60, reps: 8),
              CompletedSetDraft(weightKg: 60, reps: 7, rpe: 9),
            ],
          ),
        ],
      ),
    );
    expect(sessionId, greaterThan(0));

    final summaries = await db.sessionDao.watchSummaries().first;
    expect(summaries.length, 1);
    expect(summaries.first.setCount, 3);
    expect(summaries.first.exerciseCount, 1);
    expect(summaries.first.totalVolume, 60.0 * 8 + 60 * 8 + 60 * 7);

    final detail = await db.sessionDao.getDetail(sessionId);
    expect(detail!.exercises.first.sets.length, 3);
    expect(detail.exercises.first.sets.first.setNumber, 1);
    expect(detail.exercises.first.sets.last.rpe, 9);

    final lastSets = await db.sessionDao.lastSetsForExercise(bench.id);
    expect(lastSets.length, 3);
    expect(lastSets.first.weightKg, 60);

    final history =
        await db.sessionDao.watchSetsHistoryForExercise(bench.id).first;
    expect(history.length, 1);
    expect(history.first.sets.length, 3);

    // Records personnels : 60 kg et le 1RM d'Epley correspondant.
    final bests = await db.sessionDao.personalBests(bench.id);
    expect(bests.maxWeightKg, 60);
    expect(bests.maxOneRm, closeTo(60 * (1 + 8 / 30), 0.01));
  });

  test('instantané de séance active : sauvegarde, lecture, suppression',
      () async {
    expect(await db.sessionDao.loadActiveDraft(), isNull);
    await db.sessionDao.saveActiveDraft('{"name":"Push"}');
    await db.sessionDao.saveActiveDraft('{"name":"Push v2"}');
    expect(await db.sessionDao.loadActiveDraft(), '{"name":"Push v2"}');
    await db.sessionDao.clearActiveDraft();
    expect(await db.sessionDao.loadActiveDraft(), isNull);
  });

  test('correction et suppression d\'une séance passée', () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final squat =
        exercises.firstWhere((e) => e.exercise.name == 'Squat').exercise;
    final curl = exercises
        .firstWhere((e) => e.exercise.name == 'Curl biceps')
        .exercise;

    final sessionId = await db.sessionDao.saveCompletedSession(
      CompletedSessionDraft(
        date: DateTime(2026, 7, 11),
        templateId: null,
        name: 'Legs',
        notes: '',
        durationSeconds: 2400,
        exercises: [
          CompletedExerciseDraft(exerciseId: squat.id, sets: const [
            CompletedSetDraft(weightKg: 100, reps: 5),
            CompletedSetDraft(weightKg: 100, reps: 5),
          ]),
          CompletedExerciseDraft(exerciseId: curl.id, sets: const [
            CompletedSetDraft(weightKg: 12, reps: 12),
          ]),
        ],
      ),
    );

    final before = await db.sessionDao.getDetail(sessionId);
    final squatSets = before!.exercises.first.sets;
    final curlExercise = before.exercises.last;

    // Corrige la première série (erreur de saisie : 100 → 105), supprime la
    // seconde, et retire tout le curl.
    await db.sessionDao.applySessionCorrections(
      sessionId: sessionId,
      name: 'Legs (corrigée)',
      notes: 'Correction',
      setCorrections: [
        SetCorrection(setId: squatSets.first.id, weightKg: 105, reps: 5),
      ],
      deletedSetIds: [squatSets.last.id],
      deletedSessionExerciseIds: [curlExercise.sessionExerciseId],
    );

    final after = await db.sessionDao.getDetail(sessionId);
    expect(after!.session.name, 'Legs (corrigée)');
    expect(after.exercises.length, 1);
    expect(after.exercises.single.sets.single.weightKg, 105);

    await db.sessionDao.deleteSession(sessionId);
    expect(await db.sessionDao.getDetail(sessionId), isNull);
    expect(await db.sessionDao.watchSummaries().first, isEmpty);
  });

  test('ajout de séries et d\'exercices à une séance passée', () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final squat =
        exercises.firstWhere((e) => e.exercise.name == 'Squat').exercise;
    final curl = exercises
        .firstWhere((e) => e.exercise.name == 'Curl biceps')
        .exercise;

    final sessionId = await db.sessionDao.saveCompletedSession(
      CompletedSessionDraft(
        date: DateTime(2026, 7, 11),
        templateId: null,
        name: 'Legs',
        notes: '',
        durationSeconds: 2400,
        exercises: [
          CompletedExerciseDraft(exerciseId: squat.id, sets: const [
            CompletedSetDraft(weightKg: 100, reps: 5),
          ]),
        ],
      ),
    );

    final before = await db.sessionDao.getDetail(sessionId);
    final squatExercise = before!.exercises.single;

    // Ajoute une série oubliée au squat et tout un exercice de curl.
    await db.sessionDao.applySessionCorrections(
      sessionId: sessionId,
      name: 'Legs',
      notes: '',
      setCorrections: const [],
      deletedSetIds: const [],
      deletedSessionExerciseIds: const [],
      addedSets: [
        NewSetForExercise(
          sessionExerciseId: squatExercise.sessionExerciseId,
          weightKg: 102.5,
          reps: 4,
        ),
      ],
      addedExercises: [
        CompletedExerciseDraft(exerciseId: curl.id, sets: const [
          CompletedSetDraft(weightKg: 12, reps: 12),
          CompletedSetDraft(weightKg: 12, reps: 10),
        ]),
      ],
    );

    final after = await db.sessionDao.getDetail(sessionId);
    expect(after!.exercises.length, 2);
    final squatAfter = after.exercises.first;
    expect(squatAfter.sets.length, 2);
    expect(squatAfter.sets.last.weightKg, 102.5);
    expect(squatAfter.sets.last.setNumber, 2);
    final curlAfter = after.exercises.last;
    expect(curlAfter.exercise.id, curl.id);
    expect(curlAfter.sets.map((s) => s.reps), [12, 10]);

    // Les ajouts alimentent bien les records.
    final bests = await db.sessionDao.personalBests(curl.id);
    expect(bests.maxWeightKg, 12);
  });

  test('records datés et vue d\'ensemble des records', () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final bench = exercises
        .firstWhere((e) => e.exercise.name == 'Développé couché')
        .exercise;

    await db.sessionDao.saveCompletedSession(
      CompletedSessionDraft(
        date: DateTime(2026, 7, 1),
        templateId: null,
        name: 'Push',
        notes: '',
        durationSeconds: 1800,
        exercises: [
          CompletedExerciseDraft(exerciseId: bench.id, sets: const [
            CompletedSetDraft(weightKg: 60, reps: 10),
            CompletedSetDraft(weightKg: 70, reps: 4),
          ]),
        ],
      ),
    );
    await db.sessionDao.saveCompletedSession(
      CompletedSessionDraft(
        date: DateTime(2026, 7, 8),
        templateId: null,
        name: 'Push',
        notes: '',
        durationSeconds: 1800,
        exercises: [
          CompletedExerciseDraft(exerciseId: bench.id, sets: const [
            CompletedSetDraft(weightKg: 65, reps: 8),
          ]),
        ],
      ),
    );

    final records = await db.sessionDao.exerciseRecords(bench.id);
    expect(records.maxWeight!.value, 70);
    expect(records.maxWeight!.reps, 4);
    expect(records.maxWeight!.date, DateTime(2026, 7, 1));
    // 1RM Epley : 65 × (1 + 8/30) ≈ 82,3 > 70 × (1 + 4/30) ≈ 79,3.
    expect(records.bestOneRm!.value, closeTo(82.3, 0.1));
    expect(records.bestOneRm!.date, DateTime(2026, 7, 8));
    // Volume max : séance du 1er juillet (60×10 + 70×4 = 880).
    expect(records.bestSessionVolume!.value, 880);
    expect(records.sessionCount, 2);

    final highlights = await db.sessionDao.watchPrHighlights().first;
    final benchHighlight =
        highlights.singleWhere((h) => h.exerciseId == bench.id);
    expect(benchHighlight.maxWeightKg, 70);
    expect(benchHighlight.isDuration, isFalse);
  });

  test('exercice en durée : la Planche est mesurée en secondes', () async {
    final exercises = await db.exerciseDao.watchAllWithMuscles().first;
    final plank =
        exercises.firstWhere((e) => e.exercise.name == 'Planche');
    expect(plank.isDuration, isTrue);

    final sessionId = await db.sessionDao.saveCompletedSession(
      CompletedSessionDraft(
        date: DateTime(2026, 7, 11),
        templateId: null,
        name: 'Abdos',
        notes: '',
        durationSeconds: 600,
        exercises: [
          CompletedExerciseDraft(exerciseId: plank.exercise.id, sets: const [
            CompletedSetDraft(weightKg: 0, reps: 0, durationSeconds: 60),
            CompletedSetDraft(weightKg: 0, reps: 0, durationSeconds: 75),
          ]),
        ],
      ),
    );
    expect(sessionId, greaterThan(0));

    final bests = await db.sessionDao.personalBests(plank.exercise.id);
    expect(bests.maxDurationSeconds, 75);

    final history = await db.sessionDao
        .watchSetsHistoryForExercise(plank.exercise.id)
        .first;
    expect(history.single.sets.map((s) => s.durationSeconds), [60, 75]);
  });
}
