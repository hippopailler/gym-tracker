import 'package:drift/drift.dart';

import '../../../domain/models/exercise_models.dart';
import '../../../domain/models/muscle_groups.dart';
import '../../../domain/models/template_models.dart';
import '../database.dart';
import '../tables.dart';

part 'template_dao.g.dart';

@DriftAccessor(
  tables: [WorkoutTemplates, TemplateExercises, Exercises, ExerciseMuscles],
)
class TemplateDao extends DatabaseAccessor<AppDatabase>
    with _$TemplateDaoMixin {
  TemplateDao(super.db);

  JoinedSelectStatement<HasResultSet, dynamic> _baseQuery() {
    return select(workoutTemplates).join([
      leftOuterJoin(
        templateExercises,
        templateExercises.templateId.equalsExp(workoutTemplates.id),
      ),
      leftOuterJoin(
        exercises,
        exercises.id.equalsExp(templateExercises.exerciseId),
      ),
      leftOuterJoin(
        exerciseMuscles,
        exerciseMuscles.exerciseId.equalsExp(exercises.id),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(workoutTemplates.id),
        OrderingTerm.asc(templateExercises.position),
      ]);
  }

  List<TemplateWithExercises> _groupRows(List<TypedResult> rows) {
    final templates = <int, WorkoutTemplate>{};
    // Par template : linkId → (lien, exercice, slugs) dans l'ordre des rows.
    final items = <int, Map<int, (TemplateExercise, Exercise, Set<String>)>>{};
    for (final row in rows) {
      final template = row.readTable(workoutTemplates);
      templates[template.id] = template;
      items.putIfAbsent(template.id, () => {});
      final link = row.readTableOrNull(templateExercises);
      final exercise = row.readTableOrNull(exercises);
      if (link == null || exercise == null) continue;
      final entry = items[template.id]!
          .putIfAbsent(link.id, () => (link, exercise, <String>{}));
      final muscle = row.readTableOrNull(exerciseMuscles);
      if (muscle != null) entry.$3.add(muscle.muscleGroup);
    }
    return [
      for (final template in templates.values)
        TemplateWithExercises(
          template: template,
          exercises: [
            for (final (link, exercise, slugs) in items[template.id]!.values)
              TemplateExerciseDetail(
                link: link,
                exercise: ExerciseDetail(
                  exercise: exercise,
                  muscleSlugs: sortedMuscleSlugs(slugs),
                ),
              ),
          ],
        ),
    ];
  }

  Stream<List<TemplateWithExercises>> watchAllWithExercises() {
    return _baseQuery().watch().map(_groupRows);
  }

  Future<List<TemplateWithExercises>> getAllWithExercises() async {
    return _groupRows(await _baseQuery().get());
  }

  Future<TemplateWithExercises?> getWithExercises(int templateId) async {
    final query = _baseQuery()
      ..where(workoutTemplates.id.equals(templateId));
    final grouped = _groupRows(await query.get());
    return grouped.isEmpty ? null : grouped.first;
  }

  /// Crée ou met à jour un template et remplace la liste de ses exercices.
  Future<int> saveTemplate({
    int? id,
    required String name,
    required String description,
    required String tags,
    required List<TemplateExerciseDraft> items,
  }) {
    return transaction(() async {
      int templateId;
      if (id == null) {
        templateId = await into(workoutTemplates).insert(
          WorkoutTemplatesCompanion.insert(
            name: name,
            description: Value(description),
            tags: Value(tags),
          ),
        );
      } else {
        templateId = id;
        await (update(workoutTemplates)..where((t) => t.id.equals(id))).write(
          WorkoutTemplatesCompanion(
            name: Value(name),
            description: Value(description),
            tags: Value(tags),
          ),
        );
        await (delete(templateExercises)
              ..where((t) => t.templateId.equals(id)))
            .go();
      }
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        await into(templateExercises).insert(TemplateExercisesCompanion.insert(
          templateId: templateId,
          exerciseId: item.exerciseId,
          position: i,
          targetSets: item.targetSets,
          targetReps: item.targetReps,
          restSeconds: item.restSeconds,
        ));
      }
      return templateId;
    });
  }

  Future<int?> duplicateTemplate(int templateId) async {
    final source = await getWithExercises(templateId);
    if (source == null) return null;
    return saveTemplate(
      name: '${source.template.name} (copie)',
      description: source.template.description,
      tags: source.template.tags,
      items: [
        for (final item in source.exercises)
          TemplateExerciseDraft(
            exerciseId: item.exercise.exercise.id,
            targetSets: item.link.targetSets,
            targetReps: item.link.targetReps,
            restSeconds: item.link.restSeconds,
          ),
      ],
    );
  }

  Future<void> deleteTemplate(int templateId) {
    return (delete(workoutTemplates)..where((t) => t.id.equals(templateId)))
        .go();
  }
}
