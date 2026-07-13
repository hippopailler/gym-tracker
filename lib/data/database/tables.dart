import 'package:drift/drift.dart';

/// Types de mesure d'un exercice.
abstract class ExerciseTypes {
  /// Poids × répétitions (défaut).
  static const String reps = 'reps';

  /// Durée en secondes (planche, gainage…).
  static const String duration = 'duration';

  /// Cardio : durée + distance (rameur, skieur, course…).
  static const String cardio = 'cardio';
}

@DataClassName('Exercise')
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get equipment => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get defaultRestSeconds => integer().withDefault(const Constant(90))();

  /// Vrai pour les exercices créés par l'utilisateur (supprimables).
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// [ExerciseTypes.reps] ou [ExerciseTypes.duration].
  TextColumn get exerciseType =>
      text().withDefault(const Constant(ExerciseTypes.reps))();
}

/// Association n-n exercice ↔ groupes musculaires (slugs du catalogue
/// [kMuscleGroups]) : un exercice peut travailler plusieurs groupes.
@DataClassName('ExerciseMuscle')
class ExerciseMuscles extends Table {
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();
  TextColumn get muscleGroup => text()();

  @override
  Set<Column> get primaryKey => {exerciseId, muscleGroup};
}

@DataClassName('WorkoutTemplate')
class WorkoutTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();

  /// Tags séparés par des virgules, ex. « push,force ».
  TextColumn get tags => text().withDefault(const Constant(''))();
}

@DataClassName('TemplateExercise')
class TemplateExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId => integer()
      .references(WorkoutTemplates, #id, onDelete: KeyAction.cascade)();
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  /// Ordre de l'exercice dans le template (0 = premier).
  IntColumn get position => integer()();
  IntColumn get targetSets => integer()();
  IntColumn get targetReps => integer()();
  IntColumn get restSeconds => integer()();
}

@DataClassName('WorkoutSession')
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get templateId => integer()
      .nullable()
      .references(WorkoutTemplates, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
}

@DataClassName('SessionExercise')
class SessionExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer()
      .references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();

  /// Note libre sur l'exercice pour cette séance (réglages machine,
  /// sensations…).
  TextColumn get notes => text().withDefault(const Constant(''))();
}

@DataClassName('SetEntry')
class SetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionExerciseId => integer()
      .references(SessionExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()();
  IntColumn get restTakenSeconds => integer().nullable()();

  /// Durée effectuée, pour les exercices de type [ExerciseTypes.duration]
  /// et [ExerciseTypes.cardio].
  IntColumn get durationSeconds => integer().nullable()();

  /// Distance parcourue en mètres, pour les exercices cardio.
  RealColumn get distanceMeters => real().nullable()();
}

/// Réglages de l'application (clé → valeur) : thème, drapeaux d'import…
@DataClassName('AppSetting')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Instantané JSON de la séance en cours, sauvegardé au fil de l'eau pour
/// survivre à la fermeture de l'app. Une seule ligne (id = 1).
@DataClassName('ActiveSessionDraftRow')
class ActiveSessionDrafts extends Table {
  IntColumn get id => integer()();
  TextColumn get payload => text()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
