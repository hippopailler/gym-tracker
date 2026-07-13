import '../../domain/models/exercise_models.dart';
import '../database/database.dart';
import '../database/tables.dart';

class ExerciseRepository {
  ExerciseRepository(this._db);

  final AppDatabase _db;

  Stream<List<ExerciseDetail>> watchAll() =>
      _db.exerciseDao.watchAllWithMuscles();

  Future<Exercise> getById(int id) => _db.exerciseDao.getById(id);

  Future<int> create({
    required String name,
    required String equipment,
    String description = '',
    required int defaultRestSeconds,
    required List<String> muscleSlugs,
    String exerciseType = ExerciseTypes.reps,
  }) {
    return _db.exerciseDao.createExercise(
      name: name,
      equipment: equipment,
      description: description,
      defaultRestSeconds: defaultRestSeconds,
      muscleSlugs: muscleSlugs,
      exerciseType: exerciseType,
    );
  }

  Future<void> update({
    required int id,
    required String name,
    required String equipment,
    required String description,
    required int defaultRestSeconds,
    required List<String> muscleSlugs,
    required String exerciseType,
  }) {
    return _db.exerciseDao.updateExercise(
      id: id,
      name: name,
      equipment: equipment,
      description: description,
      defaultRestSeconds: defaultRestSeconds,
      muscleSlugs: muscleSlugs,
      exerciseType: exerciseType,
    );
  }

  Future<void> delete(int id) => _db.exerciseDao.deleteExercise(id);
}
