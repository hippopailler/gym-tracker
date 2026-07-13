import 'package:drift/drift.dart';

import '../../../domain/models/exercise_models.dart';
import '../../../domain/models/muscle_groups.dart';
import '../database.dart';
import '../tables.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises, ExerciseMuscles])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  /// Tous les exercices avec leurs groupes musculaires, triés par nom.
  Stream<List<ExerciseDetail>> watchAllWithMuscles() {
    final query = select(exercises).join([
      leftOuterJoin(
        exerciseMuscles,
        exerciseMuscles.exerciseId.equalsExp(exercises.id),
      ),
    ])
      ..orderBy([OrderingTerm.asc(exercises.name)]);

    return query.watch().map((rows) {
      final ordered = <int, Exercise>{};
      final slugs = <int, Set<String>>{};
      for (final row in rows) {
        final exercise = row.readTable(exercises);
        ordered[exercise.id] = exercise;
        slugs.putIfAbsent(exercise.id, () => {});
        final muscle = row.readTableOrNull(exerciseMuscles);
        if (muscle != null) slugs[exercise.id]!.add(muscle.muscleGroup);
      }
      return [
        for (final exercise in ordered.values)
          ExerciseDetail(
            exercise: exercise,
            muscleSlugs: sortedMuscleSlugs(slugs[exercise.id]!),
          ),
      ];
    });
  }

  Future<Exercise> getById(int id) {
    return (select(exercises)..where((e) => e.id.equals(id))).getSingle();
  }

  /// Crée un exercice (par défaut personnalisé) rattaché à un ou plusieurs
  /// groupes musculaires.
  Future<int> createExercise({
    required String name,
    required String equipment,
    String description = '',
    required int defaultRestSeconds,
    required List<String> muscleSlugs,
    bool isCustom = true,
    String exerciseType = ExerciseTypes.reps,
  }) {
    return transaction(() async {
      final id = await into(exercises).insert(ExercisesCompanion.insert(
        name: name,
        equipment: equipment,
        description: Value(description),
        defaultRestSeconds: Value(defaultRestSeconds),
        isCustom: Value(isCustom),
        exerciseType: Value(exerciseType),
      ));
      for (final slug in muscleSlugs.toSet()) {
        await into(exerciseMuscles).insert(
          ExerciseMusclesCompanion.insert(exerciseId: id, muscleGroup: slug),
        );
      }
      return id;
    });
  }

  /// Supprime un exercice (les associations et l'historique liés partent en
  /// cascade) — réservé aux exercices personnalisés côté UI.
  Future<void> deleteExercise(int id) {
    return (delete(exercises)..where((e) => e.id.equals(id))).go();
  }
}
