import '../../domain/models/progress_models.dart';
import '../../domain/models/session_models.dart';
import '../../domain/services/progression_service.dart';
import '../database/database.dart';

class SessionRepository {
  SessionRepository(this._db, this._progression);

  final AppDatabase _db;
  final ProgressionService _progression;

  Future<int> saveCompleted(CompletedSessionDraft draft) =>
      _db.sessionDao.saveCompletedSession(draft);

  Stream<List<SessionSummary>> watchSummaries() =>
      _db.sessionDao.watchSummaries();

  Stream<Set<int>> watchExerciseIdsWithData() =>
      _db.sessionDao.watchExerciseIdsWithData();

  Future<SessionDetail?> getDetail(int sessionId) =>
      _db.sessionDao.getDetail(sessionId);

  Future<List<SetEntry>> lastSetsForExercise(int exerciseId) =>
      _db.sessionDao.lastSetsForExercise(exerciseId);

  Future<String> lastNoteForExercise(int exerciseId) =>
      _db.sessionDao.lastNoteForExercise(exerciseId);

  Future<PersonalBests> personalBests(int exerciseId) =>
      _db.sessionDao.personalBests(exerciseId);

  Future<ExerciseRecords> exerciseRecords(int exerciseId) =>
      _db.sessionDao.exerciseRecords(exerciseId);

  Stream<List<PrHighlight>> watchPrHighlights() =>
      _db.sessionDao.watchPrHighlights();

  Future<void> deleteSession(int sessionId) =>
      _db.sessionDao.deleteSession(sessionId);

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
    return _db.sessionDao.applySessionCorrections(
      sessionId: sessionId,
      name: name,
      notes: notes,
      setCorrections: setCorrections,
      deletedSetIds: deletedSetIds,
      deletedSessionExerciseIds: deletedSessionExerciseIds,
      addedSets: addedSets,
      addedExercises: addedExercises,
    );
  }

  // Instantané de la séance en cours.
  Future<void> saveActiveDraft(String payload) =>
      _db.sessionDao.saveActiveDraft(payload);

  Future<String?> loadActiveDraft() => _db.sessionDao.loadActiveDraft();

  Future<void> clearActiveDraft() => _db.sessionDao.clearActiveDraft();

  /// Points de progression (poids max, volume, 1RM estimé) par séance.
  Stream<List<ExerciseProgressPoint>> watchProgress(int exerciseId) {
    return _db.sessionDao.watchSetsHistoryForExercise(exerciseId).map(
          (history) => [
            for (final entry in history)
              _progression.progressPoint(date: entry.date, sets: entry.sets),
          ],
        );
  }
}
