// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutTemplatesTable get workoutTemplates =>
      attachedDatabase.workoutTemplates;
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $SessionExercisesTable get sessionExercises =>
      attachedDatabase.sessionExercises;
  $SetEntriesTable get setEntries => attachedDatabase.setEntries;
  $ActiveSessionDraftsTable get activeSessionDrafts =>
      attachedDatabase.activeSessionDrafts;
  SessionDaoManager get managers => SessionDaoManager(this);
}

class SessionDaoManager {
  final _$SessionDaoMixin _db;
  SessionDaoManager(this._db);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(
          _db.attachedDatabase, _db.workoutTemplates);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
          _db.attachedDatabase, _db.workoutSessions);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(
          _db.attachedDatabase, _db.sessionExercises);
  $$SetEntriesTableTableManager get setEntries =>
      $$SetEntriesTableTableManager(_db.attachedDatabase, _db.setEntries);
  $$ActiveSessionDraftsTableTableManager get activeSessionDrafts =>
      $$ActiveSessionDraftsTableTableManager(
          _db.attachedDatabase, _db.activeSessionDrafts);
}
