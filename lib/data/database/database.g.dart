// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
      'default_rest_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(90));
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _exerciseTypeMeta =
      const VerificationMeta('exerciseType');
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
      'exercise_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(ExerciseTypes.reps));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        equipment,
        description,
        defaultRestSeconds,
        isCustom,
        exerciseType
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
          _defaultRestSecondsMeta,
          defaultRestSeconds.isAcceptableOrUnknown(
              data['default_rest_seconds']!, _defaultRestSecondsMeta));
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
          _exerciseTypeMeta,
          exerciseType.isAcceptableOrUnknown(
              data['exercise_type']!, _exerciseTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      defaultRestSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_rest_seconds'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      exerciseType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_type'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String equipment;
  final String description;
  final int defaultRestSeconds;

  /// Vrai pour les exercices créés par l'utilisateur (supprimables).
  final bool isCustom;

  /// [ExerciseTypes.reps] ou [ExerciseTypes.duration].
  final String exerciseType;
  const Exercise(
      {required this.id,
      required this.name,
      required this.equipment,
      required this.description,
      required this.defaultRestSeconds,
      required this.isCustom,
      required this.exerciseType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['equipment'] = Variable<String>(equipment);
    map['description'] = Variable<String>(description);
    map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    map['is_custom'] = Variable<bool>(isCustom);
    map['exercise_type'] = Variable<String>(exerciseType);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      equipment: Value(equipment),
      description: Value(description),
      defaultRestSeconds: Value(defaultRestSeconds),
      isCustom: Value(isCustom),
      exerciseType: Value(exerciseType),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      equipment: serializer.fromJson<String>(json['equipment']),
      description: serializer.fromJson<String>(json['description']),
      defaultRestSeconds: serializer.fromJson<int>(json['defaultRestSeconds']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'equipment': serializer.toJson<String>(equipment),
      'description': serializer.toJson<String>(description),
      'defaultRestSeconds': serializer.toJson<int>(defaultRestSeconds),
      'isCustom': serializer.toJson<bool>(isCustom),
      'exerciseType': serializer.toJson<String>(exerciseType),
    };
  }

  Exercise copyWith(
          {int? id,
          String? name,
          String? equipment,
          String? description,
          int? defaultRestSeconds,
          bool? isCustom,
          String? exerciseType}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        equipment: equipment ?? this.equipment,
        description: description ?? this.description,
        defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
        isCustom: isCustom ?? this.isCustom,
        exerciseType: exerciseType ?? this.exerciseType,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      description:
          data.description.present ? data.description.value : this.description,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipment: $equipment, ')
          ..write('description: $description, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('isCustom: $isCustom, ')
          ..write('exerciseType: $exerciseType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, equipment, description,
      defaultRestSeconds, isCustom, exerciseType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.equipment == this.equipment &&
          other.description == this.description &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.isCustom == this.isCustom &&
          other.exerciseType == this.exerciseType);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> equipment;
  final Value<String> description;
  final Value<int> defaultRestSeconds;
  final Value<bool> isCustom;
  final Value<String> exerciseType;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.equipment = const Value.absent(),
    this.description = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.exerciseType = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String equipment,
    this.description = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.exerciseType = const Value.absent(),
  })  : name = Value(name),
        equipment = Value(equipment);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? equipment,
    Expression<String>? description,
    Expression<int>? defaultRestSeconds,
    Expression<bool>? isCustom,
    Expression<String>? exerciseType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (equipment != null) 'equipment': equipment,
      if (description != null) 'description': description,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (isCustom != null) 'is_custom': isCustom,
      if (exerciseType != null) 'exercise_type': exerciseType,
    });
  }

  ExercisesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? equipment,
      Value<String>? description,
      Value<int>? defaultRestSeconds,
      Value<bool>? isCustom,
      Value<String>? exerciseType}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      description: description ?? this.description,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      isCustom: isCustom ?? this.isCustom,
      exerciseType: exerciseType ?? this.exerciseType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipment: $equipment, ')
          ..write('description: $description, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('isCustom: $isCustom, ')
          ..write('exerciseType: $exerciseType')
          ..write(')'))
        .toString();
  }
}

class $ExerciseMusclesTable extends ExerciseMuscles
    with TableInfo<$ExerciseMusclesTable, ExerciseMuscle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseMusclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _muscleGroupMeta =
      const VerificationMeta('muscleGroup');
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
      'muscle_group', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [exerciseId, muscleGroup];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_muscles';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseMuscle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
          _muscleGroupMeta,
          muscleGroup.isAcceptableOrUnknown(
              data['muscle_group']!, _muscleGroupMeta));
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId, muscleGroup};
  @override
  ExerciseMuscle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseMuscle(
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      muscleGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}muscle_group'])!,
    );
  }

  @override
  $ExerciseMusclesTable createAlias(String alias) {
    return $ExerciseMusclesTable(attachedDatabase, alias);
  }
}

class ExerciseMuscle extends DataClass implements Insertable<ExerciseMuscle> {
  final int exerciseId;
  final String muscleGroup;
  const ExerciseMuscle({required this.exerciseId, required this.muscleGroup});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<int>(exerciseId);
    map['muscle_group'] = Variable<String>(muscleGroup);
    return map;
  }

  ExerciseMusclesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseMusclesCompanion(
      exerciseId: Value(exerciseId),
      muscleGroup: Value(muscleGroup),
    );
  }

  factory ExerciseMuscle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseMuscle(
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<int>(exerciseId),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
    };
  }

  ExerciseMuscle copyWith({int? exerciseId, String? muscleGroup}) =>
      ExerciseMuscle(
        exerciseId: exerciseId ?? this.exerciseId,
        muscleGroup: muscleGroup ?? this.muscleGroup,
      );
  ExerciseMuscle copyWithCompanion(ExerciseMusclesCompanion data) {
    return ExerciseMuscle(
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      muscleGroup:
          data.muscleGroup.present ? data.muscleGroup.value : this.muscleGroup,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseMuscle(')
          ..write('exerciseId: $exerciseId, ')
          ..write('muscleGroup: $muscleGroup')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(exerciseId, muscleGroup);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseMuscle &&
          other.exerciseId == this.exerciseId &&
          other.muscleGroup == this.muscleGroup);
}

class ExerciseMusclesCompanion extends UpdateCompanion<ExerciseMuscle> {
  final Value<int> exerciseId;
  final Value<String> muscleGroup;
  final Value<int> rowid;
  const ExerciseMusclesCompanion({
    this.exerciseId = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseMusclesCompanion.insert({
    required int exerciseId,
    required String muscleGroup,
    this.rowid = const Value.absent(),
  })  : exerciseId = Value(exerciseId),
        muscleGroup = Value(muscleGroup);
  static Insertable<ExerciseMuscle> custom({
    Expression<int>? exerciseId,
    Expression<String>? muscleGroup,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseMusclesCompanion copyWith(
      {Value<int>? exerciseId, Value<String>? muscleGroup, Value<int>? rowid}) {
    return ExerciseMusclesCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseMusclesCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplatesTable extends WorkoutTemplates
    with TableInfo<$WorkoutTemplatesTable, WorkoutTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, name, description, tags];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
    );
  }

  @override
  $WorkoutTemplatesTable createAlias(String alias) {
    return $WorkoutTemplatesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplate extends DataClass implements Insertable<WorkoutTemplate> {
  final int id;
  final String name;
  final String description;

  /// Tags séparés par des virgules, ex. « push,force ».
  final String tags;
  const WorkoutTemplate(
      {required this.id,
      required this.name,
      required this.description,
      required this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['tags'] = Variable<String>(tags);
    return map;
  }

  WorkoutTemplatesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      tags: Value(tags),
    );
  }

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'tags': serializer.toJson<String>(tags),
    };
  }

  WorkoutTemplate copyWith(
          {int? id, String? name, String? description, String? tags}) =>
      WorkoutTemplate(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        tags: tags ?? this.tags,
      );
  WorkoutTemplate copyWithCompanion(WorkoutTemplatesCompanion data) {
    return WorkoutTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.tags == this.tags);
}

class WorkoutTemplatesCompanion extends UpdateCompanion<WorkoutTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> tags;
  const WorkoutTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
  });
  WorkoutTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
  }) : name = Value(name);
  static Insertable<WorkoutTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? tags,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
    });
  }

  WorkoutTemplatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? tags}) {
    return WorkoutTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }
}

class $TemplateExercisesTable extends TemplateExercises
    with TableInfo<$TemplateExercisesTable, TemplateExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_templates (id) ON DELETE CASCADE'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetSetsMeta =
      const VerificationMeta('targetSets');
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
      'target_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetRepsMeta =
      const VerificationMeta('targetReps');
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
      'target_reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _restSecondsMeta =
      const VerificationMeta('restSeconds');
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
      'rest_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        templateId,
        exerciseId,
        position,
        targetSets,
        targetReps,
        restSeconds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_exercises';
  @override
  VerificationContext validateIntegrity(Insertable<TemplateExercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
          _targetSetsMeta,
          targetSets.isAcceptableOrUnknown(
              data['target_sets']!, _targetSetsMeta));
    } else if (isInserting) {
      context.missing(_targetSetsMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
          _targetRepsMeta,
          targetReps.isAcceptableOrUnknown(
              data['target_reps']!, _targetRepsMeta));
    } else if (isInserting) {
      context.missing(_targetRepsMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
          _restSecondsMeta,
          restSeconds.isAcceptableOrUnknown(
              data['rest_seconds']!, _restSecondsMeta));
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateExercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      targetSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_sets'])!,
      targetReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_reps'])!,
      restSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_seconds'])!,
    );
  }

  @override
  $TemplateExercisesTable createAlias(String alias) {
    return $TemplateExercisesTable(attachedDatabase, alias);
  }
}

class TemplateExercise extends DataClass
    implements Insertable<TemplateExercise> {
  final int id;
  final int templateId;
  final int exerciseId;

  /// Ordre de l'exercice dans le template (0 = premier).
  final int position;
  final int targetSets;
  final int targetReps;
  final int restSeconds;
  const TemplateExercise(
      {required this.id,
      required this.templateId,
      required this.exerciseId,
      required this.position,
      required this.targetSets,
      required this.targetReps,
      required this.restSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['position'] = Variable<int>(position);
    map['target_sets'] = Variable<int>(targetSets);
    map['target_reps'] = Variable<int>(targetReps);
    map['rest_seconds'] = Variable<int>(restSeconds);
    return map;
  }

  TemplateExercisesCompanion toCompanion(bool nullToAbsent) {
    return TemplateExercisesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      exerciseId: Value(exerciseId),
      position: Value(position),
      targetSets: Value(targetSets),
      targetReps: Value(targetReps),
      restSeconds: Value(restSeconds),
    );
  }

  factory TemplateExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateExercise(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      position: serializer.fromJson<int>(json['position']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      targetReps: serializer.fromJson<int>(json['targetReps']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'position': serializer.toJson<int>(position),
      'targetSets': serializer.toJson<int>(targetSets),
      'targetReps': serializer.toJson<int>(targetReps),
      'restSeconds': serializer.toJson<int>(restSeconds),
    };
  }

  TemplateExercise copyWith(
          {int? id,
          int? templateId,
          int? exerciseId,
          int? position,
          int? targetSets,
          int? targetReps,
          int? restSeconds}) =>
      TemplateExercise(
        id: id ?? this.id,
        templateId: templateId ?? this.templateId,
        exerciseId: exerciseId ?? this.exerciseId,
        position: position ?? this.position,
        targetSets: targetSets ?? this.targetSets,
        targetReps: targetReps ?? this.targetReps,
        restSeconds: restSeconds ?? this.restSeconds,
      );
  TemplateExercise copyWithCompanion(TemplateExercisesCompanion data) {
    return TemplateExercise(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      position: data.position.present ? data.position.value : this.position,
      targetSets:
          data.targetSets.present ? data.targetSets.value : this.targetSets,
      targetReps:
          data.targetReps.present ? data.targetReps.value : this.targetReps,
      restSeconds:
          data.restSeconds.present ? data.restSeconds.value : this.restSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercise(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, exerciseId, position,
      targetSets, targetReps, restSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateExercise &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.exerciseId == this.exerciseId &&
          other.position == this.position &&
          other.targetSets == this.targetSets &&
          other.targetReps == this.targetReps &&
          other.restSeconds == this.restSeconds);
}

class TemplateExercisesCompanion extends UpdateCompanion<TemplateExercise> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<int> exerciseId;
  final Value<int> position;
  final Value<int> targetSets;
  final Value<int> targetReps;
  final Value<int> restSeconds;
  const TemplateExercisesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.restSeconds = const Value.absent(),
  });
  TemplateExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required int exerciseId,
    required int position,
    required int targetSets,
    required int targetReps,
    required int restSeconds,
  })  : templateId = Value(templateId),
        exerciseId = Value(exerciseId),
        position = Value(position),
        targetSets = Value(targetSets),
        targetReps = Value(targetReps),
        restSeconds = Value(restSeconds);
  static Insertable<TemplateExercise> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<int>? exerciseId,
    Expression<int>? position,
    Expression<int>? targetSets,
    Expression<int>? targetReps,
    Expression<int>? restSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (position != null) 'position': position,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetReps != null) 'target_reps': targetReps,
      if (restSeconds != null) 'rest_seconds': restSeconds,
    });
  }

  TemplateExercisesCompanion copyWith(
      {Value<int>? id,
      Value<int>? templateId,
      Value<int>? exerciseId,
      Value<int>? position,
      Value<int>? targetSets,
      Value<int>? targetReps,
      Value<int>? restSeconds}) {
    return TemplateExercisesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercisesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_templates (id) ON DELETE SET NULL'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, templateId, name, notes, durationSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final DateTime date;
  final int? templateId;
  final String name;
  final String notes;
  final int durationSeconds;
  const WorkoutSession(
      {required this.id,
      required this.date,
      this.templateId,
      required this.name,
      required this.notes,
      required this.durationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    map['name'] = Variable<String>(name);
    map['notes'] = Variable<String>(notes);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      date: Value(date),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      name: Value(name),
      notes: Value(notes),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String>(json['notes']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'templateId': serializer.toJson<int?>(templateId),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String>(notes),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  WorkoutSession copyWith(
          {int? id,
          DateTime? date,
          Value<int?> templateId = const Value.absent(),
          String? name,
          String? notes,
          int? durationSeconds}) =>
      WorkoutSession(
        id: id ?? this.id,
        date: date ?? this.date,
        templateId: templateId.present ? templateId.value : this.templateId,
        name: name ?? this.name,
        notes: notes ?? this.notes,
        durationSeconds: durationSeconds ?? this.durationSeconds,
      );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('templateId: $templateId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, templateId, name, notes, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.templateId == this.templateId &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.durationSeconds == this.durationSeconds);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> templateId;
  final Value<String> name;
  final Value<String> notes;
  final Value<int> durationSeconds;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.templateId = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.templateId = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  })  : date = Value(date),
        name = Value(name);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? templateId,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (templateId != null) 'template_id': templateId,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int?>? templateId,
      Value<String>? name,
      Value<String>? notes,
      Value<int>? durationSeconds}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('templateId: $templateId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $SessionExercisesTable extends SessionExercises
    with TableInfo<$SessionExercisesTable, SessionExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_sessions (id) ON DELETE CASCADE'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, exerciseId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercises';
  @override
  VerificationContext validateIntegrity(Insertable<SessionExercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $SessionExercisesTable createAlias(String alias) {
    return $SessionExercisesTable(attachedDatabase, alias);
  }
}

class SessionExercise extends DataClass implements Insertable<SessionExercise> {
  final int id;
  final int sessionId;
  final int exerciseId;
  final int position;
  const SessionExercise(
      {required this.id,
      required this.sessionId,
      required this.exerciseId,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['position'] = Variable<int>(position);
    return map;
  }

  SessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return SessionExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      position: Value(position),
    );
  }

  factory SessionExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExercise(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'position': serializer.toJson<int>(position),
    };
  }

  SessionExercise copyWith(
          {int? id, int? sessionId, int? exerciseId, int? position}) =>
      SessionExercise(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        exerciseId: exerciseId ?? this.exerciseId,
        position: position ?? this.position,
      );
  SessionExercise copyWithCompanion(SessionExercisesCompanion data) {
    return SessionExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, exerciseId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.position == this.position);
}

class SessionExercisesCompanion extends UpdateCompanion<SessionExercise> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> exerciseId;
  final Value<int> position;
  const SessionExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.position = const Value.absent(),
  });
  SessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int exerciseId,
    required int position,
  })  : sessionId = Value(sessionId),
        exerciseId = Value(exerciseId),
        position = Value(position);
  static Insertable<SessionExercise> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? exerciseId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (position != null) 'position': position,
    });
  }

  SessionExercisesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? exerciseId,
      Value<int>? position}) {
    return SessionExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $SetEntriesTable extends SetEntries
    with TableInfo<$SetEntriesTable, SetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionExerciseIdMeta =
      const VerificationMeta('sessionExerciseId');
  @override
  late final GeneratedColumn<int> sessionExerciseId = GeneratedColumn<int>(
      'session_exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES session_exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _setNumberMeta =
      const VerificationMeta('setNumber');
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
      'set_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
      'rpe', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _restTakenSecondsMeta =
      const VerificationMeta('restTakenSeconds');
  @override
  late final GeneratedColumn<int> restTakenSeconds = GeneratedColumn<int>(
      'rest_taken_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionExerciseId,
        setNumber,
        weightKg,
        reps,
        rpe,
        restTakenSeconds,
        durationSeconds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_entries';
  @override
  VerificationContext validateIntegrity(Insertable<SetEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
          _sessionExerciseIdMeta,
          sessionExerciseId.isAcceptableOrUnknown(
              data['session_exercise_id']!, _sessionExerciseIdMeta));
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(_setNumberMeta,
          setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta));
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
          _rpeMeta, rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta));
    }
    if (data.containsKey('rest_taken_seconds')) {
      context.handle(
          _restTakenSecondsMeta,
          restTakenSeconds.isAcceptableOrUnknown(
              data['rest_taken_seconds']!, _restTakenSecondsMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}session_exercise_id'])!,
      setNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_number'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      rpe: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rpe']),
      restTakenSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_taken_seconds']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
    );
  }

  @override
  $SetEntriesTable createAlias(String alias) {
    return $SetEntriesTable(attachedDatabase, alias);
  }
}

class SetEntry extends DataClass implements Insertable<SetEntry> {
  final int id;
  final int sessionExerciseId;
  final int setNumber;
  final double weightKg;
  final int reps;
  final double? rpe;
  final int? restTakenSeconds;

  /// Durée effectuée, pour les exercices de type [ExerciseTypes.duration].
  final int? durationSeconds;
  const SetEntry(
      {required this.id,
      required this.sessionExerciseId,
      required this.setNumber,
      required this.weightKg,
      required this.reps,
      this.rpe,
      this.restTakenSeconds,
      this.durationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_exercise_id'] = Variable<int>(sessionExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    if (!nullToAbsent || restTakenSeconds != null) {
      map['rest_taken_seconds'] = Variable<int>(restTakenSeconds);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    return map;
  }

  SetEntriesCompanion toCompanion(bool nullToAbsent) {
    return SetEntriesCompanion(
      id: Value(id),
      sessionExerciseId: Value(sessionExerciseId),
      setNumber: Value(setNumber),
      weightKg: Value(weightKg),
      reps: Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      restTakenSeconds: restTakenSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restTakenSeconds),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
    );
  }

  factory SetEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetEntry(
      id: serializer.fromJson<int>(json['id']),
      sessionExerciseId: serializer.fromJson<int>(json['sessionExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      restTakenSeconds: serializer.fromJson<int?>(json['restTakenSeconds']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionExerciseId': serializer.toJson<int>(sessionExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'restTakenSeconds': serializer.toJson<int?>(restTakenSeconds),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
    };
  }

  SetEntry copyWith(
          {int? id,
          int? sessionExerciseId,
          int? setNumber,
          double? weightKg,
          int? reps,
          Value<double?> rpe = const Value.absent(),
          Value<int?> restTakenSeconds = const Value.absent(),
          Value<int?> durationSeconds = const Value.absent()}) =>
      SetEntry(
        id: id ?? this.id,
        sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
        setNumber: setNumber ?? this.setNumber,
        weightKg: weightKg ?? this.weightKg,
        reps: reps ?? this.reps,
        rpe: rpe.present ? rpe.value : this.rpe,
        restTakenSeconds: restTakenSeconds.present
            ? restTakenSeconds.value
            : this.restTakenSeconds,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
      );
  SetEntry copyWithCompanion(SetEntriesCompanion data) {
    return SetEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      restTakenSeconds: data.restTakenSeconds.present
          ? data.restTakenSeconds.value
          : this.restTakenSeconds,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetEntry(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('restTakenSeconds: $restTakenSeconds, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionExerciseId, setNumber, weightKg,
      reps, rpe, restTakenSeconds, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetEntry &&
          other.id == this.id &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.setNumber == this.setNumber &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.restTakenSeconds == this.restTakenSeconds &&
          other.durationSeconds == this.durationSeconds);
}

class SetEntriesCompanion extends UpdateCompanion<SetEntry> {
  final Value<int> id;
  final Value<int> sessionExerciseId;
  final Value<int> setNumber;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<double?> rpe;
  final Value<int?> restTakenSeconds;
  final Value<int?> durationSeconds;
  const SetEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.restTakenSeconds = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  SetEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionExerciseId,
    required int setNumber,
    required double weightKg,
    required int reps,
    this.rpe = const Value.absent(),
    this.restTakenSeconds = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  })  : sessionExerciseId = Value(sessionExerciseId),
        setNumber = Value(setNumber),
        weightKg = Value(weightKg),
        reps = Value(reps);
  static Insertable<SetEntry> custom({
    Expression<int>? id,
    Expression<int>? sessionExerciseId,
    Expression<int>? setNumber,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<int>? restTakenSeconds,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (restTakenSeconds != null) 'rest_taken_seconds': restTakenSeconds,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  SetEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionExerciseId,
      Value<int>? setNumber,
      Value<double>? weightKg,
      Value<int>? reps,
      Value<double?>? rpe,
      Value<int?>? restTakenSeconds,
      Value<int?>? durationSeconds}) {
    return SetEntriesCompanion(
      id: id ?? this.id,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      restTakenSeconds: restTakenSeconds ?? this.restTakenSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<int>(sessionExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (restTakenSeconds.present) {
      map['rest_taken_seconds'] = Variable<int>(restTakenSeconds.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('restTakenSeconds: $restTakenSeconds, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $ActiveSessionDraftsTable extends ActiveSessionDrafts
    with TableInfo<$ActiveSessionDraftsTable, ActiveSessionDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveSessionDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, payload, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_session_drafts';
  @override
  VerificationContext validateIntegrity(
      Insertable<ActiveSessionDraftRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveSessionDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveSessionDraftRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $ActiveSessionDraftsTable createAlias(String alias) {
    return $ActiveSessionDraftsTable(attachedDatabase, alias);
  }
}

class ActiveSessionDraftRow extends DataClass
    implements Insertable<ActiveSessionDraftRow> {
  final int id;
  final String payload;
  final DateTime savedAt;
  const ActiveSessionDraftRow(
      {required this.id, required this.payload, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payload'] = Variable<String>(payload);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  ActiveSessionDraftsCompanion toCompanion(bool nullToAbsent) {
    return ActiveSessionDraftsCompanion(
      id: Value(id),
      payload: Value(payload),
      savedAt: Value(savedAt),
    );
  }

  factory ActiveSessionDraftRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveSessionDraftRow(
      id: serializer.fromJson<int>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'payload': serializer.toJson<String>(payload),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  ActiveSessionDraftRow copyWith(
          {int? id, String? payload, DateTime? savedAt}) =>
      ActiveSessionDraftRow(
        id: id ?? this.id,
        payload: payload ?? this.payload,
        savedAt: savedAt ?? this.savedAt,
      );
  ActiveSessionDraftRow copyWithCompanion(ActiveSessionDraftsCompanion data) {
    return ActiveSessionDraftRow(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveSessionDraftRow(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveSessionDraftRow &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.savedAt == this.savedAt);
}

class ActiveSessionDraftsCompanion
    extends UpdateCompanion<ActiveSessionDraftRow> {
  final Value<int> id;
  final Value<String> payload;
  final Value<DateTime> savedAt;
  const ActiveSessionDraftsCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  ActiveSessionDraftsCompanion.insert({
    this.id = const Value.absent(),
    required String payload,
    required DateTime savedAt,
  })  : payload = Value(payload),
        savedAt = Value(savedAt);
  static Insertable<ActiveSessionDraftRow> custom({
    Expression<int>? id,
    Expression<String>? payload,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  ActiveSessionDraftsCompanion copyWith(
      {Value<int>? id, Value<String>? payload, Value<DateTime>? savedAt}) {
    return ActiveSessionDraftsCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveSessionDraftsCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ExerciseMusclesTable exerciseMuscles =
      $ExerciseMusclesTable(this);
  late final $WorkoutTemplatesTable workoutTemplates =
      $WorkoutTemplatesTable(this);
  late final $TemplateExercisesTable templateExercises =
      $TemplateExercisesTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  late final $SessionExercisesTable sessionExercises =
      $SessionExercisesTable(this);
  late final $SetEntriesTable setEntries = $SetEntriesTable(this);
  late final $ActiveSessionDraftsTable activeSessionDrafts =
      $ActiveSessionDraftsTable(this);
  late final ExerciseDao exerciseDao = ExerciseDao(this as AppDatabase);
  late final TemplateDao templateDao = TemplateDao(this as AppDatabase);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        exercises,
        exerciseMuscles,
        workoutTemplates,
        templateExercises,
        workoutSessions,
        sessionExercises,
        setEntries,
        activeSessionDrafts
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exercise_muscles', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workout_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('template_exercises', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('template_exercises', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workout_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_sessions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workout_sessions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('session_exercises', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('session_exercises', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('session_exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('set_entries', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required String equipment,
  Value<String> description,
  Value<int> defaultRestSeconds,
  Value<bool> isCustom,
  Value<String> exerciseType,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> equipment,
  Value<String> description,
  Value<int> defaultRestSeconds,
  Value<bool> isCustom,
  Value<String> exerciseType,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseMusclesTable, List<ExerciseMuscle>>
      _exerciseMusclesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.exerciseMuscles,
              aliasName: 'exercises__id__exercise_muscles__exercise_id');

  $$ExerciseMusclesTableProcessedTableManager get exerciseMusclesRefs {
    final manager =
        $$ExerciseMusclesTableTableManager($_db, $_db.exerciseMuscles)
            .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_exerciseMusclesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExercise>>
      _templateExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.templateExercises,
              aliasName: 'exercises__id__template_exercises__exercise_id');

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager =
        $$TemplateExercisesTableTableManager($_db, $_db.templateExercises)
            .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_templateExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
      _sessionExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionExercises,
              aliasName: 'exercises__id__session_exercises__exercise_id');

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager =
        $$SessionExercisesTableTableManager($_db, $_db.sessionExercises)
            .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseType => $composableBuilder(
      column: $table.exerciseType, builder: (column) => ColumnFilters(column));

  Expression<bool> exerciseMusclesRefs(
      Expression<bool> Function($$ExerciseMusclesTableFilterComposer f) f) {
    final $$ExerciseMusclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exerciseMuscles,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseMusclesTableFilterComposer(
              $db: $db,
              $table: $db.exerciseMuscles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> templateExercisesRefs(
      Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.templateExercises,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplateExercisesTableFilterComposer(
              $db: $db,
              $table: $db.templateExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
      Expression<bool> Function($$SessionExercisesTableFilterComposer f) f) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableFilterComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseType => $composableBuilder(
      column: $table.exerciseType,
      builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
      column: $table.exerciseType, builder: (column) => column);

  Expression<T> exerciseMusclesRefs<T extends Object>(
      Expression<T> Function($$ExerciseMusclesTableAnnotationComposer a) f) {
    final $$ExerciseMusclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exerciseMuscles,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseMusclesTableAnnotationComposer(
              $db: $db,
              $table: $db.exerciseMuscles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> templateExercisesRefs<T extends Object>(
      Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.templateExercises,
            getReferencedColumn: (t) => t.exerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TemplateExercisesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.templateExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
      Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function(
        {bool exerciseMusclesRefs,
        bool templateExercisesRefs,
        bool sessionExercisesRefs})> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> defaultRestSeconds = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<String> exerciseType = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            name: name,
            equipment: equipment,
            description: description,
            defaultRestSeconds: defaultRestSeconds,
            isCustom: isCustom,
            exerciseType: exerciseType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String equipment,
            Value<String> description = const Value.absent(),
            Value<int> defaultRestSeconds = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<String> exerciseType = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            name: name,
            equipment: equipment,
            description: description,
            defaultRestSeconds: defaultRestSeconds,
            isCustom: isCustom,
            exerciseType: exerciseType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {exerciseMusclesRefs = false,
              templateExercisesRefs = false,
              sessionExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (exerciseMusclesRefs) db.exerciseMuscles,
                if (templateExercisesRefs) db.templateExercises,
                if (sessionExercisesRefs) db.sessionExercises
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exerciseMusclesRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable,
                            ExerciseMuscle>(
                        currentTable: table,
                        referencedTable: $$ExercisesTableReferences
                            ._exerciseMusclesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .exerciseMusclesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items),
                  if (templateExercisesRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable,
                            TemplateExercise>(
                        currentTable: table,
                        referencedTable: $$ExercisesTableReferences
                            ._templateExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .templateExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items),
                  if (sessionExercisesRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable,
                            SessionExercise>(
                        currentTable: table,
                        referencedTable: $$ExercisesTableReferences
                            ._sessionExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .sessionExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function(
        {bool exerciseMusclesRefs,
        bool templateExercisesRefs,
        bool sessionExercisesRefs})>;
typedef $$ExerciseMusclesTableCreateCompanionBuilder = ExerciseMusclesCompanion
    Function({
  required int exerciseId,
  required String muscleGroup,
  Value<int> rowid,
});
typedef $$ExerciseMusclesTableUpdateCompanionBuilder = ExerciseMusclesCompanion
    Function({
  Value<int> exerciseId,
  Value<String> muscleGroup,
  Value<int> rowid,
});

final class $$ExerciseMusclesTableReferences extends BaseReferences<
    _$AppDatabase, $ExerciseMusclesTable, ExerciseMuscle> {
  $$ExerciseMusclesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('exercise_muscles__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExerciseMusclesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseMusclesTable> {
  $$ExerciseMusclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => ColumnFilters(column));

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseMusclesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseMusclesTable> {
  $$ExerciseMusclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => ColumnOrderings(column));

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseMusclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseMusclesTable> {
  $$ExerciseMusclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseMusclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseMusclesTable,
    ExerciseMuscle,
    $$ExerciseMusclesTableFilterComposer,
    $$ExerciseMusclesTableOrderingComposer,
    $$ExerciseMusclesTableAnnotationComposer,
    $$ExerciseMusclesTableCreateCompanionBuilder,
    $$ExerciseMusclesTableUpdateCompanionBuilder,
    (ExerciseMuscle, $$ExerciseMusclesTableReferences),
    ExerciseMuscle,
    PrefetchHooks Function({bool exerciseId})> {
  $$ExerciseMusclesTableTableManager(
      _$AppDatabase db, $ExerciseMusclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseMusclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseMusclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseMusclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> exerciseId = const Value.absent(),
            Value<String> muscleGroup = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseMusclesCompanion(
            exerciseId: exerciseId,
            muscleGroup: muscleGroup,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int exerciseId,
            required String muscleGroup,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseMusclesCompanion.insert(
            exerciseId: exerciseId,
            muscleGroup: muscleGroup,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExerciseMusclesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$ExerciseMusclesTableReferences._exerciseIdTable(db),
                    referencedColumn: $$ExerciseMusclesTableReferences
                        ._exerciseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExerciseMusclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseMusclesTable,
    ExerciseMuscle,
    $$ExerciseMusclesTableFilterComposer,
    $$ExerciseMusclesTableOrderingComposer,
    $$ExerciseMusclesTableAnnotationComposer,
    $$ExerciseMusclesTableCreateCompanionBuilder,
    $$ExerciseMusclesTableUpdateCompanionBuilder,
    (ExerciseMuscle, $$ExerciseMusclesTableReferences),
    ExerciseMuscle,
    PrefetchHooks Function({bool exerciseId})>;
typedef $$WorkoutTemplatesTableCreateCompanionBuilder
    = WorkoutTemplatesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> description,
  Value<String> tags,
});
typedef $$WorkoutTemplatesTableUpdateCompanionBuilder
    = WorkoutTemplatesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> tags,
});

final class $$WorkoutTemplatesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutTemplatesTable, WorkoutTemplate> {
  $$WorkoutTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExercise>>
      _templateExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.templateExercises,
              aliasName:
                  'workout_templates__id__template_exercises__template_id');

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager =
        $$TemplateExercisesTableTableManager($_db, $_db.templateExercises)
            .filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_templateExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
      _workoutSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutSessions,
              aliasName:
                  'workout_templates__id__workout_sessions__template_id');

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager =
        $$WorkoutSessionsTableTableManager($_db, $_db.workoutSessions)
            .filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  Expression<bool> templateExercisesRefs(
      Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.templateExercises,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplateExercisesTableFilterComposer(
              $db: $db,
              $table: $db.templateExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
      Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  Expression<T> templateExercisesRefs<T extends Object>(
      Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.templateExercises,
            getReferencedColumn: (t) => t.templateId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TemplateExercisesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.templateExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
      Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutTemplatesTable,
    WorkoutTemplate,
    $$WorkoutTemplatesTableFilterComposer,
    $$WorkoutTemplatesTableOrderingComposer,
    $$WorkoutTemplatesTableAnnotationComposer,
    $$WorkoutTemplatesTableCreateCompanionBuilder,
    $$WorkoutTemplatesTableUpdateCompanionBuilder,
    (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
    WorkoutTemplate,
    PrefetchHooks Function(
        {bool templateExercisesRefs, bool workoutSessionsRefs})> {
  $$WorkoutTemplatesTableTableManager(
      _$AppDatabase db, $WorkoutTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
          }) =>
              WorkoutTemplatesCompanion(
            id: id,
            name: name,
            description: description,
            tags: tags,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
          }) =>
              WorkoutTemplatesCompanion.insert(
            id: id,
            name: name,
            description: description,
            tags: tags,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {templateExercisesRefs = false, workoutSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateExercisesRefs) db.templateExercises,
                if (workoutSessionsRefs) db.workoutSessions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateExercisesRefs)
                    await $_getPrefetchedData<WorkoutTemplate,
                            $WorkoutTemplatesTable, TemplateExercise>(
                        currentTable: table,
                        referencedTable: $$WorkoutTemplatesTableReferences
                            ._templateExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutTemplatesTableReferences(db, table, p0)
                                .templateExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items),
                  if (workoutSessionsRefs)
                    await $_getPrefetchedData<WorkoutTemplate,
                            $WorkoutTemplatesTable, WorkoutSession>(
                        currentTable: table,
                        referencedTable: $$WorkoutTemplatesTableReferences
                            ._workoutSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutTemplatesTableReferences(db, table, p0)
                                .workoutSessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutTemplatesTable,
    WorkoutTemplate,
    $$WorkoutTemplatesTableFilterComposer,
    $$WorkoutTemplatesTableOrderingComposer,
    $$WorkoutTemplatesTableAnnotationComposer,
    $$WorkoutTemplatesTableCreateCompanionBuilder,
    $$WorkoutTemplatesTableUpdateCompanionBuilder,
    (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
    WorkoutTemplate,
    PrefetchHooks Function(
        {bool templateExercisesRefs, bool workoutSessionsRefs})>;
typedef $$TemplateExercisesTableCreateCompanionBuilder
    = TemplateExercisesCompanion Function({
  Value<int> id,
  required int templateId,
  required int exerciseId,
  required int position,
  required int targetSets,
  required int targetReps,
  required int restSeconds,
});
typedef $$TemplateExercisesTableUpdateCompanionBuilder
    = TemplateExercisesCompanion Function({
  Value<int> id,
  Value<int> templateId,
  Value<int> exerciseId,
  Value<int> position,
  Value<int> targetSets,
  Value<int> targetReps,
  Value<int> restSeconds,
});

final class $$TemplateExercisesTableReferences extends BaseReferences<
    _$AppDatabase, $TemplateExercisesTable, TemplateExercise> {
  $$TemplateExercisesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .workoutTemplates
      .createAlias('template_exercises__template_id__workout_templates__id');

  $$WorkoutTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager =
        $$WorkoutTemplatesTableTableManager($_db, $_db.workoutTemplates)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('template_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TemplateExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetSets => $composableBuilder(
      column: $table.targetSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetReps => $composableBuilder(
      column: $table.targetReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnFilters(column));

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TemplateExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetSets => $composableBuilder(
      column: $table.targetSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetReps => $composableBuilder(
      column: $table.targetReps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnOrderings(column));

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TemplateExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
      column: $table.targetSets, builder: (column) => column);

  GeneratedColumn<int> get targetReps => $composableBuilder(
      column: $table.targetReps, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TemplateExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemplateExercisesTable,
    TemplateExercise,
    $$TemplateExercisesTableFilterComposer,
    $$TemplateExercisesTableOrderingComposer,
    $$TemplateExercisesTableAnnotationComposer,
    $$TemplateExercisesTableCreateCompanionBuilder,
    $$TemplateExercisesTableUpdateCompanionBuilder,
    (TemplateExercise, $$TemplateExercisesTableReferences),
    TemplateExercise,
    PrefetchHooks Function({bool templateId, bool exerciseId})> {
  $$TemplateExercisesTableTableManager(
      _$AppDatabase db, $TemplateExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateExercisesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> templateId = const Value.absent(),
            Value<int> exerciseId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> targetSets = const Value.absent(),
            Value<int> targetReps = const Value.absent(),
            Value<int> restSeconds = const Value.absent(),
          }) =>
              TemplateExercisesCompanion(
            id: id,
            templateId: templateId,
            exerciseId: exerciseId,
            position: position,
            targetSets: targetSets,
            targetReps: targetReps,
            restSeconds: restSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int templateId,
            required int exerciseId,
            required int position,
            required int targetSets,
            required int targetReps,
            required int restSeconds,
          }) =>
              TemplateExercisesCompanion.insert(
            id: id,
            templateId: templateId,
            exerciseId: exerciseId,
            position: position,
            targetSets: targetSets,
            targetReps: targetReps,
            restSeconds: restSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TemplateExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({templateId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$TemplateExercisesTableReferences._templateIdTable(db),
                    referencedColumn: $$TemplateExercisesTableReferences
                        ._templateIdTable(db)
                        .id,
                  ) as T;
                }
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$TemplateExercisesTableReferences._exerciseIdTable(db),
                    referencedColumn: $$TemplateExercisesTableReferences
                        ._exerciseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TemplateExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemplateExercisesTable,
    TemplateExercise,
    $$TemplateExercisesTableFilterComposer,
    $$TemplateExercisesTableOrderingComposer,
    $$TemplateExercisesTableAnnotationComposer,
    $$TemplateExercisesTableCreateCompanionBuilder,
    $$TemplateExercisesTableUpdateCompanionBuilder,
    (TemplateExercise, $$TemplateExercisesTableReferences),
    TemplateExercise,
    PrefetchHooks Function({bool templateId, bool exerciseId})>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  Value<int?> templateId,
  required String name,
  Value<String> notes,
  Value<int> durationSeconds,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int?> templateId,
  Value<String> name,
  Value<String> notes,
  Value<int> durationSeconds,
});

final class $$WorkoutSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.workoutTemplates
          .createAlias('workout_sessions__template_id__workout_templates__id');

  $$WorkoutTemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<int>('template_id');
    if ($_column == null) return null;
    final manager =
        $$WorkoutTemplatesTableTableManager($_db, $_db.workoutTemplates)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
      _sessionExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionExercises,
              aliasName: 'workout_sessions__id__session_exercises__session_id');

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager =
        $$SessionExercisesTableTableManager($_db, $_db.sessionExercises)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sessionExercisesRefs(
      Expression<bool> Function($$SessionExercisesTableFilterComposer f) f) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableFilterComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
      Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSession, $$WorkoutSessionsTableReferences),
    WorkoutSession,
    PrefetchHooks Function({bool templateId, bool sessionExercisesRefs})> {
  $$WorkoutSessionsTableTableManager(
      _$AppDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> templateId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            date: date,
            templateId: templateId,
            name: name,
            notes: notes,
            durationSeconds: durationSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<int?> templateId = const Value.absent(),
            required String name,
            Value<String> notes = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            date: date,
            templateId: templateId,
            name: name,
            notes: notes,
            durationSeconds: durationSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {templateId = false, sessionExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionExercisesRefs) db.sessionExercises
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$WorkoutSessionsTableReferences._templateIdTable(db),
                    referencedColumn: $$WorkoutSessionsTableReferences
                        ._templateIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionExercisesRefs)
                    await $_getPrefetchedData<WorkoutSession,
                            $WorkoutSessionsTable, SessionExercise>(
                        currentTable: table,
                        referencedTable: $$WorkoutSessionsTableReferences
                            ._sessionExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutSessionsTableReferences(db, table, p0)
                                .sessionExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSession, $$WorkoutSessionsTableReferences),
    WorkoutSession,
    PrefetchHooks Function({bool templateId, bool sessionExercisesRefs})>;
typedef $$SessionExercisesTableCreateCompanionBuilder
    = SessionExercisesCompanion Function({
  Value<int> id,
  required int sessionId,
  required int exerciseId,
  required int position,
});
typedef $$SessionExercisesTableUpdateCompanionBuilder
    = SessionExercisesCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> exerciseId,
  Value<int> position,
});

final class $$SessionExercisesTableReferences extends BaseReferences<
    _$AppDatabase, $SessionExercisesTable, SessionExercise> {
  $$SessionExercisesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions
          .createAlias('session_exercises__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$WorkoutSessionsTableTableManager($_db, $_db.workoutSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('session_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SetEntriesTable, List<SetEntry>>
      _setEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.setEntries,
          aliasName: 'session_exercises__id__set_entries__session_exercise_id');

  $$SetEntriesTableProcessedTableManager get setEntriesRefs {
    final manager = $$SetEntriesTableTableManager($_db, $_db.setEntries).filter(
        (f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> setEntriesRefs(
      Expression<bool> Function($$SetEntriesTableFilterComposer f) f) {
    final $$SetEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setEntries,
        getReferencedColumn: (t) => t.sessionExerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetEntriesTableFilterComposer(
              $db: $db,
              $table: $db.setEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> setEntriesRefs<T extends Object>(
      Expression<T> Function($$SetEntriesTableAnnotationComposer a) f) {
    final $$SetEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setEntries,
        getReferencedColumn: (t) => t.sessionExerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.setEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessionExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionExercisesTable,
    SessionExercise,
    $$SessionExercisesTableFilterComposer,
    $$SessionExercisesTableOrderingComposer,
    $$SessionExercisesTableAnnotationComposer,
    $$SessionExercisesTableCreateCompanionBuilder,
    $$SessionExercisesTableUpdateCompanionBuilder,
    (SessionExercise, $$SessionExercisesTableReferences),
    SessionExercise,
    PrefetchHooks Function(
        {bool sessionId, bool exerciseId, bool setEntriesRefs})> {
  $$SessionExercisesTableTableManager(
      _$AppDatabase db, $SessionExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> exerciseId = const Value.absent(),
            Value<int> position = const Value.absent(),
          }) =>
              SessionExercisesCompanion(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            position: position,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int exerciseId,
            required int position,
          }) =>
              SessionExercisesCompanion.insert(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            position: position,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SessionExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sessionId = false, exerciseId = false, setEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setEntriesRefs) db.setEntries],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$SessionExercisesTableReferences._sessionIdTable(db),
                    referencedColumn: $$SessionExercisesTableReferences
                        ._sessionIdTable(db)
                        .id,
                  ) as T;
                }
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$SessionExercisesTableReferences._exerciseIdTable(db),
                    referencedColumn: $$SessionExercisesTableReferences
                        ._exerciseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setEntriesRefs)
                    await $_getPrefetchedData<SessionExercise, $SessionExercisesTable,
                            SetEntry>(
                        currentTable: table,
                        referencedTable: $$SessionExercisesTableReferences
                            ._setEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionExercisesTableReferences(db, table, p0)
                                .setEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionExerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SessionExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionExercisesTable,
    SessionExercise,
    $$SessionExercisesTableFilterComposer,
    $$SessionExercisesTableOrderingComposer,
    $$SessionExercisesTableAnnotationComposer,
    $$SessionExercisesTableCreateCompanionBuilder,
    $$SessionExercisesTableUpdateCompanionBuilder,
    (SessionExercise, $$SessionExercisesTableReferences),
    SessionExercise,
    PrefetchHooks Function(
        {bool sessionId, bool exerciseId, bool setEntriesRefs})>;
typedef $$SetEntriesTableCreateCompanionBuilder = SetEntriesCompanion Function({
  Value<int> id,
  required int sessionExerciseId,
  required int setNumber,
  required double weightKg,
  required int reps,
  Value<double?> rpe,
  Value<int?> restTakenSeconds,
  Value<int?> durationSeconds,
});
typedef $$SetEntriesTableUpdateCompanionBuilder = SetEntriesCompanion Function({
  Value<int> id,
  Value<int> sessionExerciseId,
  Value<int> setNumber,
  Value<double> weightKg,
  Value<int> reps,
  Value<double?> rpe,
  Value<int?> restTakenSeconds,
  Value<int?> durationSeconds,
});

final class $$SetEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $SetEntriesTable, SetEntry> {
  $$SetEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionExercisesTable _sessionExerciseIdTable(_$AppDatabase db) => db
      .sessionExercises
      .createAlias('set_entries__session_exercise_id__session_exercises__id');

  $$SessionExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<int>('session_exercise_id')!;

    final manager =
        $$SessionExercisesTableTableManager($_db, $_db.sessionExercises)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SetEntriesTable> {
  $$SetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restTakenSeconds => $composableBuilder(
      column: $table.restTakenSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  $$SessionExercisesTableFilterComposer get sessionExerciseId {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionExerciseId,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableFilterComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SetEntriesTable> {
  $$SetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restTakenSeconds => $composableBuilder(
      column: $table.restTakenSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  $$SessionExercisesTableOrderingComposer get sessionExerciseId {
    final $$SessionExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionExerciseId,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetEntriesTable> {
  $$SetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get restTakenSeconds => $composableBuilder(
      column: $table.restTakenSeconds, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  $$SessionExercisesTableAnnotationComposer get sessionExerciseId {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionExerciseId,
        referencedTable: $db.sessionExercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SetEntriesTable,
    SetEntry,
    $$SetEntriesTableFilterComposer,
    $$SetEntriesTableOrderingComposer,
    $$SetEntriesTableAnnotationComposer,
    $$SetEntriesTableCreateCompanionBuilder,
    $$SetEntriesTableUpdateCompanionBuilder,
    (SetEntry, $$SetEntriesTableReferences),
    SetEntry,
    PrefetchHooks Function({bool sessionExerciseId})> {
  $$SetEntriesTableTableManager(_$AppDatabase db, $SetEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionExerciseId = const Value.absent(),
            Value<int> setNumber = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<double?> rpe = const Value.absent(),
            Value<int?> restTakenSeconds = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
          }) =>
              SetEntriesCompanion(
            id: id,
            sessionExerciseId: sessionExerciseId,
            setNumber: setNumber,
            weightKg: weightKg,
            reps: reps,
            rpe: rpe,
            restTakenSeconds: restTakenSeconds,
            durationSeconds: durationSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionExerciseId,
            required int setNumber,
            required double weightKg,
            required int reps,
            Value<double?> rpe = const Value.absent(),
            Value<int?> restTakenSeconds = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
          }) =>
              SetEntriesCompanion.insert(
            id: id,
            sessionExerciseId: sessionExerciseId,
            setNumber: setNumber,
            weightKg: weightKg,
            reps: reps,
            rpe: rpe,
            restTakenSeconds: restTakenSeconds,
            durationSeconds: durationSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SetEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionExerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionExerciseId,
                    referencedTable:
                        $$SetEntriesTableReferences._sessionExerciseIdTable(db),
                    referencedColumn: $$SetEntriesTableReferences
                        ._sessionExerciseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SetEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SetEntriesTable,
    SetEntry,
    $$SetEntriesTableFilterComposer,
    $$SetEntriesTableOrderingComposer,
    $$SetEntriesTableAnnotationComposer,
    $$SetEntriesTableCreateCompanionBuilder,
    $$SetEntriesTableUpdateCompanionBuilder,
    (SetEntry, $$SetEntriesTableReferences),
    SetEntry,
    PrefetchHooks Function({bool sessionExerciseId})>;
typedef $$ActiveSessionDraftsTableCreateCompanionBuilder
    = ActiveSessionDraftsCompanion Function({
  Value<int> id,
  required String payload,
  required DateTime savedAt,
});
typedef $$ActiveSessionDraftsTableUpdateCompanionBuilder
    = ActiveSessionDraftsCompanion Function({
  Value<int> id,
  Value<String> payload,
  Value<DateTime> savedAt,
});

class $$ActiveSessionDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveSessionDraftsTable> {
  $$ActiveSessionDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$ActiveSessionDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveSessionDraftsTable> {
  $$ActiveSessionDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$ActiveSessionDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveSessionDraftsTable> {
  $$ActiveSessionDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$ActiveSessionDraftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActiveSessionDraftsTable,
    ActiveSessionDraftRow,
    $$ActiveSessionDraftsTableFilterComposer,
    $$ActiveSessionDraftsTableOrderingComposer,
    $$ActiveSessionDraftsTableAnnotationComposer,
    $$ActiveSessionDraftsTableCreateCompanionBuilder,
    $$ActiveSessionDraftsTableUpdateCompanionBuilder,
    (
      ActiveSessionDraftRow,
      BaseReferences<_$AppDatabase, $ActiveSessionDraftsTable,
          ActiveSessionDraftRow>
    ),
    ActiveSessionDraftRow,
    PrefetchHooks Function()> {
  $$ActiveSessionDraftsTableTableManager(
      _$AppDatabase db, $ActiveSessionDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveSessionDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveSessionDraftsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveSessionDraftsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              ActiveSessionDraftsCompanion(
            id: id,
            payload: payload,
            savedAt: savedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String payload,
            required DateTime savedAt,
          }) =>
              ActiveSessionDraftsCompanion.insert(
            id: id,
            payload: payload,
            savedAt: savedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActiveSessionDraftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActiveSessionDraftsTable,
    ActiveSessionDraftRow,
    $$ActiveSessionDraftsTableFilterComposer,
    $$ActiveSessionDraftsTableOrderingComposer,
    $$ActiveSessionDraftsTableAnnotationComposer,
    $$ActiveSessionDraftsTableCreateCompanionBuilder,
    $$ActiveSessionDraftsTableUpdateCompanionBuilder,
    (
      ActiveSessionDraftRow,
      BaseReferences<_$AppDatabase, $ActiveSessionDraftsTable,
          ActiveSessionDraftRow>
    ),
    ActiveSessionDraftRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ExerciseMusclesTableTableManager get exerciseMuscles =>
      $$ExerciseMusclesTableTableManager(_db, _db.exerciseMuscles);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(_db, _db.workoutTemplates);
  $$TemplateExercisesTableTableManager get templateExercises =>
      $$TemplateExercisesTableTableManager(_db, _db.templateExercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(_db, _db.sessionExercises);
  $$SetEntriesTableTableManager get setEntries =>
      $$SetEntriesTableTableManager(_db, _db.setEntries);
  $$ActiveSessionDraftsTableTableManager get activeSessionDrafts =>
      $$ActiveSessionDraftsTableTableManager(_db, _db.activeSessionDrafts);
}
