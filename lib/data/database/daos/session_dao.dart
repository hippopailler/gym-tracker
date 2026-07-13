import 'package:drift/drift.dart';

import '../../../domain/models/progress_models.dart';
import '../../../domain/models/session_models.dart';
import '../database.dart';
import '../tables.dart';

part 'session_dao.g.dart';

/// Séries d'un exercice pour une séance donnée, utilisé pour la progression.
class SessionSetsForExercise {
  const SessionSetsForExercise({required this.date, required this.sets});

  final DateTime date;
  final List<SetEntry> sets;
}

@DriftAccessor(
  tables: [
    WorkoutSessions,
    SessionExercises,
    SetEntries,
    Exercises,
    ActiveSessionDrafts,
  ],
)
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  // ----- Séance en cours (instantané survivant à la fermeture) -----

  Future<void> saveActiveDraft(String payload) {
    return into(activeSessionDrafts).insertOnConflictUpdate(
      ActiveSessionDraftsCompanion(
        id: const Value(1),
        payload: Value(payload),
        savedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<String?> loadActiveDraft() async {
    final row = await (select(activeSessionDrafts)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    return row?.payload;
  }

  Future<void> clearActiveDraft() {
    return (delete(activeSessionDrafts)..where((t) => t.id.equals(1))).go();
  }

  // ----- Records personnels -----

  /// Records historiques d'un exercice, toutes séances confondues.
  Future<PersonalBests> personalBests(int exerciseId) async {
    final row = await customSelect(
      '''
      SELECT
        MAX(s.weight_kg) AS max_weight,
        MAX(s.weight_kg * (1 + s.reps / 30.0)) AS max_one_rm,
        MAX(s.duration_seconds) AS max_duration
      FROM set_entries s
      INNER JOIN session_exercises se ON se.id = s.session_exercise_id
      WHERE se.exercise_id = ?
      ''',
      variables: [Variable.withInt(exerciseId)],
      readsFrom: {setEntries, sessionExercises},
    ).getSingle();
    return PersonalBests(
      maxWeightKg: row.read<double?>('max_weight') ?? 0,
      maxOneRm: row.read<double?>('max_one_rm') ?? 0,
      maxDurationSeconds: row.read<int?>('max_duration') ?? 0,
    );
  }

  /// Records datés d'un exercice (fiche exercice : tableau des PR).
  Future<ExerciseRecords> exerciseRecords(int exerciseId) async {
    Future<QueryRow?> bestSet(String orderExpr, String condition) {
      return customSelect(
        '''
        SELECT s.weight_kg AS weight, s.reps AS reps,
               s.duration_seconds AS duration, w.date AS date
        FROM set_entries s
        INNER JOIN session_exercises se ON se.id = s.session_exercise_id
        INNER JOIN workout_sessions w ON w.id = se.session_id
        WHERE se.exercise_id = ? AND $condition
        ORDER BY $orderExpr DESC, w.date ASC
        LIMIT 1
        ''',
        variables: [Variable.withInt(exerciseId)],
        readsFrom: {setEntries, sessionExercises, workoutSessions},
      ).getSingleOrNull();
    }

    final weightRow = await bestSet('s.weight_kg', 's.weight_kg > 0');
    final oneRmRow = await bestSet('s.weight_kg * (1 + s.reps / 30.0)',
        's.weight_kg > 0 AND s.reps > 0');
    final durationRow = await bestSet(
        's.duration_seconds', 'COALESCE(s.duration_seconds, 0) > 0');
    final volumeRow = await customSelect(
      '''
      SELECT SUM(s.weight_kg * s.reps) AS volume, w.date AS date
      FROM set_entries s
      INNER JOIN session_exercises se ON se.id = s.session_exercise_id
      INNER JOIN workout_sessions w ON w.id = se.session_id
      WHERE se.exercise_id = ?
      GROUP BY se.session_id
      HAVING SUM(s.weight_kg * s.reps) > 0
      ORDER BY volume DESC, w.date ASC
      LIMIT 1
      ''',
      variables: [Variable.withInt(exerciseId)],
      readsFrom: {setEntries, sessionExercises, workoutSessions},
    ).getSingleOrNull();
    final countRow = await customSelect(
      'SELECT COUNT(DISTINCT session_id) AS n FROM session_exercises '
      'WHERE exercise_id = ?',
      variables: [Variable.withInt(exerciseId)],
      readsFrom: {sessionExercises},
    ).getSingle();

    return ExerciseRecords(
      maxWeight: weightRow == null
          ? null
          : PrEntry(
              value: weightRow.read<double>('weight'),
              reps: weightRow.read<int>('reps'),
              date: weightRow.read<DateTime>('date'),
            ),
      bestOneRm: oneRmRow == null
          ? null
          : PrEntry(
              value: oneRmRow.read<double>('weight') *
                  (1 + oneRmRow.read<int>('reps') / 30.0),
              date: oneRmRow.read<DateTime>('date'),
            ),
      maxDuration: durationRow == null
          ? null
          : PrEntry(
              value: durationRow.read<int>('duration').toDouble(),
              date: durationRow.read<DateTime>('date'),
            ),
      bestSessionVolume: volumeRow == null
          ? null
          : PrEntry(
              value: volumeRow.read<double>('volume'),
              date: volumeRow.read<DateTime>('date'),
            ),
      sessionCount: countRow.read<int>('n'),
    );
  }

  /// Vue d'ensemble des records par exercice, mise à jour en continu
  /// (alimente la carte « records » de l'accueil).
  Stream<List<PrHighlight>> watchPrHighlights() {
    return customSelect(
      '''
      SELECT e.id AS id, e.name AS name, e.exercise_type AS type,
             MAX(s.weight_kg) AS max_weight,
             MAX(s.weight_kg * (1 + s.reps / 30.0)) AS max_one_rm,
             MAX(COALESCE(s.duration_seconds, 0)) AS max_duration
      FROM set_entries s
      INNER JOIN session_exercises se ON se.id = s.session_exercise_id
      INNER JOIN exercises e ON e.id = se.exercise_id
      GROUP BY e.id
      HAVING MAX(s.weight_kg) > 0 OR MAX(COALESCE(s.duration_seconds, 0)) > 0
      ''',
      readsFrom: {setEntries, sessionExercises, exercises},
    ).watch().map((rows) => [
          for (final row in rows)
            PrHighlight(
              exerciseId: row.read<int>('id'),
              exerciseName: row.read<String>('name'),
              // Durée et cardio : le record pertinent est la durée max.
              isDuration: row.read<String>('type') != ExerciseTypes.reps,
              maxWeightKg: row.read<double?>('max_weight') ?? 0,
              maxOneRm: row.read<double?>('max_one_rm') ?? 0,
              maxDurationSeconds: row.read<int?>('max_duration') ?? 0,
            ),
        ]);
  }

  // ----- Édition / suppression de séances passées -----

  Future<void> deleteSession(int sessionId) {
    return (delete(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .go();
  }

  /// Applique les corrections d'une séance passée : métadonnées, valeurs de
  /// séries, suppressions de séries et d'exercices entiers, ajouts de
  /// séries sur des exercices existants et ajouts d'exercices complets.
  Future<void> applySessionCorrections({
    required int sessionId,
    required String name,
    required String notes,
    required List<SetCorrection> setCorrections,
    required List<int> deletedSetIds,
    required List<int> deletedSessionExerciseIds,
    List<NewSetForExercise> addedSets = const [],
    List<CompletedExerciseDraft> addedExercises = const [],
  }) {
    return transaction(() async {
      await (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
          .write(WorkoutSessionsCompanion(
        name: Value(name),
        notes: Value(notes),
      ));
      for (final correction in setCorrections) {
        await (update(setEntries)
              ..where((s) => s.id.equals(correction.setId)))
            .write(SetEntriesCompanion(
          weightKg: Value(correction.weightKg),
          reps: Value(correction.reps),
          durationSeconds: Value(correction.durationSeconds),
        ));
      }
      if (deletedSetIds.isNotEmpty) {
        await (delete(setEntries)..where((s) => s.id.isIn(deletedSetIds)))
            .go();
      }
      if (deletedSessionExerciseIds.isNotEmpty) {
        await (delete(sessionExercises)
              ..where((s) => s.id.isIn(deletedSessionExerciseIds)))
            .go();
      }
      for (final added in addedSets) {
        final numberRow = await customSelect(
          'SELECT COALESCE(MAX(set_number), 0) AS max_number '
          'FROM set_entries WHERE session_exercise_id = ?',
          variables: [Variable.withInt(added.sessionExerciseId)],
          readsFrom: {setEntries},
        ).getSingle();
        await into(setEntries).insert(SetEntriesCompanion.insert(
          sessionExerciseId: added.sessionExerciseId,
          setNumber: numberRow.read<int>('max_number') + 1,
          weightKg: added.weightKg,
          reps: added.reps,
          durationSeconds: Value(added.durationSeconds),
        ));
      }
      if (addedExercises.isNotEmpty) {
        final positionRow = await customSelect(
          'SELECT COALESCE(MAX(position), -1) AS max_position '
          'FROM session_exercises WHERE session_id = ?',
          variables: [Variable.withInt(sessionId)],
          readsFrom: {sessionExercises},
        ).getSingle();
        var position = positionRow.read<int>('max_position') + 1;
        for (final exercise in addedExercises) {
          final sessionExerciseId = await into(sessionExercises).insert(
            SessionExercisesCompanion.insert(
              sessionId: sessionId,
              exerciseId: exercise.exerciseId,
              position: position++,
            ),
          );
          for (var s = 0; s < exercise.sets.length; s++) {
            final set = exercise.sets[s];
            await into(setEntries).insert(SetEntriesCompanion.insert(
              sessionExerciseId: sessionExerciseId,
              setNumber: s + 1,
              weightKg: set.weightKg,
              reps: set.reps,
              durationSeconds: Value(set.durationSeconds),
            ));
          }
        }
      }
    });
  }

  /// Persiste une séance complète (séance + exercices + séries).
  Future<int> saveCompletedSession(CompletedSessionDraft draft) {
    return transaction(() async {
      final sessionId = await into(workoutSessions).insert(
        WorkoutSessionsCompanion.insert(
          date: draft.date,
          templateId: Value(draft.templateId),
          name: draft.name,
          notes: Value(draft.notes),
          durationSeconds: Value(draft.durationSeconds),
        ),
      );
      for (var i = 0; i < draft.exercises.length; i++) {
        final exercise = draft.exercises[i];
        final sessionExerciseId = await into(sessionExercises).insert(
          SessionExercisesCompanion.insert(
            sessionId: sessionId,
            exerciseId: exercise.exerciseId,
            position: i,
            notes: Value(exercise.notes),
          ),
        );
        for (var s = 0; s < exercise.sets.length; s++) {
          final set = exercise.sets[s];
          await into(setEntries).insert(SetEntriesCompanion.insert(
            sessionExerciseId: sessionExerciseId,
            setNumber: s + 1,
            weightKg: set.weightKg,
            reps: set.reps,
            rpe: Value(set.rpe),
            restTakenSeconds: Value(set.restTakenSeconds),
            durationSeconds: Value(set.durationSeconds),
            distanceMeters: Value(set.distanceMeters),
          ));
        }
      }
      return sessionId;
    });
  }

  /// Toutes les séances avec agrégats (nb exercices, nb séries, volume),
  /// triées de la plus récente à la plus ancienne.
  Stream<List<SessionSummary>> watchSummaries() {
    final query = select(workoutSessions).join([
      leftOuterJoin(
        sessionExercises,
        sessionExercises.sessionId.equalsExp(workoutSessions.id),
      ),
      leftOuterJoin(
        setEntries,
        setEntries.sessionExerciseId.equalsExp(sessionExercises.id),
      ),
    ])
      ..orderBy([OrderingTerm.desc(workoutSessions.date)]);

    return query.watch().map((rows) {
      final sessions = <int, WorkoutSession>{};
      final exerciseIds = <int, Set<int>>{};
      final setIds = <int, Set<int>>{};
      final volumes = <int, double>{};
      for (final row in rows) {
        final session = row.readTable(workoutSessions);
        sessions[session.id] = session;
        exerciseIds.putIfAbsent(session.id, () => {});
        setIds.putIfAbsent(session.id, () => {});
        volumes.putIfAbsent(session.id, () => 0);
        final sessionExercise = row.readTableOrNull(sessionExercises);
        if (sessionExercise != null) {
          exerciseIds[session.id]!.add(sessionExercise.id);
        }
        final set = row.readTableOrNull(setEntries);
        if (set != null && setIds[session.id]!.add(set.id)) {
          volumes[session.id] = volumes[session.id]! + set.weightKg * set.reps;
        }
      }
      return [
        for (final session in sessions.values)
          SessionSummary(
            session: session,
            exerciseCount: exerciseIds[session.id]!.length,
            setCount: setIds[session.id]!.length,
            totalVolume: volumes[session.id]!,
          ),
      ];
    });
  }

  /// Détail complet d'une séance (exercices + séries, dans l'ordre).
  Future<SessionDetail?> getDetail(int sessionId) async {
    final session = await (select(workoutSessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingleOrNull();
    if (session == null) return null;

    final exerciseRows = await (select(sessionExercises).join([
      innerJoin(exercises, exercises.id.equalsExp(sessionExercises.exerciseId)),
    ])
          ..where(sessionExercises.sessionId.equals(sessionId))
          ..orderBy([OrderingTerm.asc(sessionExercises.position)]))
        .get();

    final details = <SessionExerciseDetail>[];
    for (final row in exerciseRows) {
      final sessionExercise = row.readTable(sessionExercises);
      final exercise = row.readTable(exercises);
      final sets = await (select(setEntries)
            ..where((s) => s.sessionExerciseId.equals(sessionExercise.id))
            ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
          .get();
      details.add(SessionExerciseDetail(
        sessionExerciseId: sessionExercise.id,
        exercise: exercise,
        sets: sets,
        notes: sessionExercise.notes,
      ));
    }
    return SessionDetail(session: session, exercises: details);
  }

  /// Séries de la dernière séance où cet exercice a été réalisé.
  Future<List<SetEntry>> lastSetsForExercise(int exerciseId) async {
    final rows = await (select(sessionExercises).join([
      innerJoin(
        workoutSessions,
        workoutSessions.id.equalsExp(sessionExercises.sessionId),
      ),
    ])
          ..where(sessionExercises.exerciseId.equals(exerciseId))
          ..orderBy([
            OrderingTerm.desc(workoutSessions.date),
            OrderingTerm.desc(sessionExercises.id),
          ])
          ..limit(1))
        .get();
    if (rows.isEmpty) return [];
    final sessionExercise = rows.first.readTable(sessionExercises);
    return (select(setEntries)
          ..where((s) => s.sessionExerciseId.equals(sessionExercise.id))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .get();
  }

  /// Dernière note laissée sur cet exercice (rappel des réglages machine
  /// à la séance suivante).
  Future<String> lastNoteForExercise(int exerciseId) async {
    final row = await customSelect(
      '''
      SELECT se.notes AS notes
      FROM session_exercises se
      INNER JOIN workout_sessions w ON w.id = se.session_id
      WHERE se.exercise_id = ? AND se.notes != ''
      ORDER BY w.date DESC, se.id DESC
      LIMIT 1
      ''',
      variables: [Variable.withInt(exerciseId)],
      readsFrom: {sessionExercises, workoutSessions},
    ).getSingleOrNull();
    return row?.read<String>('notes') ?? '';
  }

  /// Historique des séries d'un exercice, groupées par séance et triées
  /// par date croissante — matière première des graphiques de progression.
  Stream<List<SessionSetsForExercise>> watchSetsHistoryForExercise(
      int exerciseId) {
    final query = select(setEntries).join([
      innerJoin(
        sessionExercises,
        sessionExercises.id.equalsExp(setEntries.sessionExerciseId),
      ),
      innerJoin(
        workoutSessions,
        workoutSessions.id.equalsExp(sessionExercises.sessionId),
      ),
    ])
      ..where(sessionExercises.exerciseId.equals(exerciseId))
      ..orderBy([
        OrderingTerm.asc(workoutSessions.date),
        OrderingTerm.asc(setEntries.setNumber),
      ]);

    return query.watch().map((rows) {
      final bySession = <int, SessionSetsForExercise>{};
      final setsBySession = <int, List<SetEntry>>{};
      for (final row in rows) {
        final session = row.readTable(workoutSessions);
        final set = row.readTable(setEntries);
        setsBySession.putIfAbsent(session.id, () => []).add(set);
        bySession[session.id] = SessionSetsForExercise(
          date: session.date,
          sets: setsBySession[session.id]!,
        );
      }
      return bySession.values.toList();
    });
  }
}
