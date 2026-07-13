/// Point de progression d'un exercice pour une séance donnée.
class ExerciseProgressPoint {
  const ExerciseProgressPoint({
    required this.date,
    required this.maxWeightKg,
    required this.totalVolume,
    required this.estimatedOneRm,
    this.maxDurationSeconds = 0,
    this.totalDurationSeconds = 0,
  });

  final DateTime date;

  /// Poids maximal soulevé pendant la séance.
  final double maxWeightKg;

  /// Volume total (somme des poids × répétitions).
  final double totalVolume;

  /// Meilleur 1RM estimé de la séance (formule d'Epley).
  final double estimatedOneRm;

  /// Pour les exercices en durée : meilleure série et cumul de la séance.
  final int maxDurationSeconds;
  final int totalDurationSeconds;
}

/// Suggestion pour la prochaine séance, basée sur la dernière performance.
class PerformanceSuggestion {
  const PerformanceSuggestion({
    required this.weightKg,
    required this.reps,
    required this.increased,
    this.isDuration = false,
    this.durationSeconds = 0,
  });

  final double weightKg;
  final int reps;

  /// Vrai si la suggestion propose une progression.
  final bool increased;

  /// Exercice mesuré en secondes : [durationSeconds] fait foi.
  final bool isDuration;
  final int durationSeconds;

  Map<String, dynamic> toJson() => {
        'weightKg': weightKg,
        'reps': reps,
        'increased': increased,
        'isDuration': isDuration,
        'durationSeconds': durationSeconds,
      };

  static PerformanceSuggestion fromJson(Map<String, dynamic> json) {
    return PerformanceSuggestion(
      weightKg: (json['weightKg'] as num).toDouble(),
      reps: json['reps'] as int,
      increased: json['increased'] as bool,
      isDuration: json['isDuration'] as bool? ?? false,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
    );
  }
}

/// Records personnels historiques d'un exercice (toutes séances confondues).
class PersonalBests {
  const PersonalBests({
    this.maxWeightKg = 0,
    this.maxOneRm = 0,
    this.maxDurationSeconds = 0,
  });

  final double maxWeightKg;
  final double maxOneRm;
  final int maxDurationSeconds;

  PersonalBests copyWith({
    double? maxWeightKg,
    double? maxOneRm,
    int? maxDurationSeconds,
  }) {
    return PersonalBests(
      maxWeightKg: maxWeightKg ?? this.maxWeightKg,
      maxOneRm: maxOneRm ?? this.maxOneRm,
      maxDurationSeconds: maxDurationSeconds ?? this.maxDurationSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'maxWeightKg': maxWeightKg,
        'maxOneRm': maxOneRm,
        'maxDurationSeconds': maxDurationSeconds,
      };

  static PersonalBests fromJson(Map<String, dynamic> json) {
    return PersonalBests(
      maxWeightKg: (json['maxWeightKg'] as num?)?.toDouble() ?? 0,
      maxOneRm: (json['maxOneRm'] as num?)?.toDouble() ?? 0,
      maxDurationSeconds: json['maxDurationSeconds'] as int? ?? 0,
    );
  }
}

/// Record battu pendant la séance, à célébrer 🎉.
class PrCelebration {
  const PrCelebration({required this.message});

  final String message;
}

/// Un record daté (valeur + jour où il a été établi).
class PrEntry {
  const PrEntry({required this.value, required this.date, this.reps});

  final double value;
  final DateTime date;

  /// Répétitions réalisées le jour du record de poids, si pertinent.
  final int? reps;
}

/// Tableau des records personnels d'un exercice, avec leurs dates.
class ExerciseRecords {
  const ExerciseRecords({
    this.maxWeight,
    this.bestOneRm,
    this.maxDuration,
    this.bestSessionVolume,
    this.sessionCount = 0,
  });

  /// Poids max soulevé (avec les reps de ce jour-là).
  final PrEntry? maxWeight;

  /// Meilleur 1RM estimé (Epley).
  final PrEntry? bestOneRm;

  /// Meilleure durée tenue (exercices en secondes).
  final PrEntry? maxDuration;

  /// Meilleur volume cumulé sur une séance.
  final PrEntry? bestSessionVolume;

  /// Nombre de séances où l'exercice a été réalisé.
  final int sessionCount;

  bool get isEmpty => maxWeight == null && maxDuration == null;
}

/// Record mis en avant sur l'accueil (rotation quotidienne).
class PrHighlight {
  const PrHighlight({
    required this.exerciseId,
    required this.exerciseName,
    required this.isDuration,
    required this.maxWeightKg,
    required this.maxOneRm,
    required this.maxDurationSeconds,
  });

  final int exerciseId;
  final String exerciseName;
  final bool isDuration;
  final double maxWeightKg;
  final double maxOneRm;
  final int maxDurationSeconds;
}
