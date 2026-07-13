// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_dao.dart';

// ignore_for_file: type=lint
mixin _$TemplateDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutTemplatesTable get workoutTemplates =>
      attachedDatabase.workoutTemplates;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $TemplateExercisesTable get templateExercises =>
      attachedDatabase.templateExercises;
  $ExerciseMusclesTable get exerciseMuscles => attachedDatabase.exerciseMuscles;
  TemplateDaoManager get managers => TemplateDaoManager(this);
}

class TemplateDaoManager {
  final _$TemplateDaoMixin _db;
  TemplateDaoManager(this._db);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(
          _db.attachedDatabase, _db.workoutTemplates);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$TemplateExercisesTableTableManager get templateExercises =>
      $$TemplateExercisesTableTableManager(
          _db.attachedDatabase, _db.templateExercises);
  $$ExerciseMusclesTableTableManager get exerciseMuscles =>
      $$ExerciseMusclesTableTableManager(
          _db.attachedDatabase, _db.exerciseMuscles);
}
