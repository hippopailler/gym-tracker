/// Historique d'entraînement (mars → juillet 2026) transcrit depuis les
/// notes personnelles (mind map par exercice). Importé une seule fois en
/// base par la migration v4 (drapeau `history_imported` dans app_settings).
///
/// Conventions de lecture des notes (validées avec l'utilisateur) :
/// - `poids x reps` = une série ; `poids x reps x n` = n séries identiques ;
/// - un nombre seul = série au poids du corps (poids enregistré à 0 kg) ;
/// - pour Tractions/Dips, `A x B` = A kg de lest × B répétitions ;
/// - les entrées sans date des notes ont été ignorées ;
/// - coquilles de dates corrigées selon la chronologie du mind map
///   (épaules 24/04→24/03, élévations 10/05→15/05, dos 5/6→5/7).
library;

class HistoryEntry {
  const HistoryEntry(this.page, this.exercise, this.day, this.sets,
      {this.note = ''});

  /// Page des notes (groupe musculaire) — sert à nommer la séance.
  final String page;

  /// Nom exact de l'exercice dans le catalogue.
  final String exercise;

  /// Date au format `jj/mm` (année [kHistoryYear]).
  final String day;

  /// Séries : `poids x reps[ x n]` séparées par `/`, nombre seul = poids
  /// du corps.
  final String sets;

  /// Note d'exercice reprise des annotations d'origine.
  final String note;
}

const int kHistoryYear = 2026;

class HistorySet {
  const HistorySet(this.weightKg, this.reps);

  final double weightKg;
  final int reps;
}

/// Décompose une spécification de séries (`50x12/57x10x3`) en séries
/// individuelles. Lance une [FormatException] sur une entrée illisible.
List<HistorySet> parseHistorySets(String spec) {
  final result = <HistorySet>[];
  for (final raw in spec.split('/')) {
    final token = raw.trim();
    if (token.isEmpty) continue;
    final parts = token.split('x').map((p) => p.trim()).toList();
    switch (parts.length) {
      case 1:
        result.add(HistorySet(0, int.parse(parts[0])));
      case 2:
        result.add(HistorySet(double.parse(parts[0]), int.parse(parts[1])));
      case 3:
        final set = HistorySet(double.parse(parts[0]), int.parse(parts[1]));
        result.addAll(List.filled(int.parse(parts[2]), set));
      default:
        throw FormatException('Série illisible : « $token »');
    }
  }
  return result;
}

const List<HistoryEntry> kHistoryEntries = [
  // ----- Pecs -----
  HistoryEntry('Pecs', 'Chest press', '17/03', '43x12/57x10x3'),
  HistoryEntry('Pecs', 'Chest press', '26/03', '23x8/50x8/50x10/50x12x2'),
  HistoryEntry('Pecs', 'Chest press', '01/04', '50x10/50x12/57x10x2'),
  HistoryEntry('Pecs', 'Chest press', '07/04', '18x15/50x13/57x10x2/63x8'),
  HistoryEntry('Pecs', 'Chest press', '13/04', '57x10x4'),
  HistoryEntry('Pecs', 'Chest press', '22/04', '50x12/57x15/63x10x2'),
  HistoryEntry('Pecs', 'Chest press', '29/04', '50x12/57x12x3'),
  HistoryEntry('Pecs', 'Chest press', '16/05', '50x12/57x12/63x8x2'),
  HistoryEntry('Pecs', 'Chest press', '04/06', '50x10/57x12x2/63x8'),
  HistoryEntry('Pecs', 'Chest press', '11/06', '57x12x2/63x10x2'),
  HistoryEntry('Pecs', 'Chest press', '30/06', '57x10x2/57x12x2'),
  HistoryEntry('Pecs', 'Papillons', '17/03', '32x12/45x12/52x12/59x10'),
  HistoryEntry('Pecs', 'Papillons', '26/03', '52x12/59x15/66x12x2'),
  HistoryEntry('Pecs', 'Papillons', '01/04', '66x13x2/73x10x2'),
  HistoryEntry('Pecs', 'Papillons', '07/04', '66x12x2/73x10x2'),
  HistoryEntry('Pecs', 'Papillons', '13/04', '66x15/73x12x3'),
  HistoryEntry('Pecs', 'Papillons', '22/04', '66x12/73x12/79x10/79x12'),
  HistoryEntry('Pecs', 'Papillons', '29/04', '66x15/73x12/79x12x2'),
  HistoryEntry('Pecs', 'Papillons', '08/05', '73x15/79x12x3'),
  HistoryEntry('Pecs', 'Papillons', '16/05', '79x12x3/86x8'),
  HistoryEntry('Pecs', 'Papillons', '04/06', '79x10x3'),
  HistoryEntry('Pecs', 'Papillons', '11/06', '79x10/79x12x2/86x10'),
  HistoryEntry('Pecs', 'Papillons', '30/06', '73x12/79x10x3'),
  HistoryEntry('Pecs', 'Dips', '17/03', '12/15x10/20x10/30x2',
      note: 'La clavicule droite, tu connais'),
  HistoryEntry('Pecs', 'Dips', '26/03', '12/12/20x10'),
  HistoryEntry('Pecs', 'Dips', '07/04', '12/10x13/20x10'),
  HistoryEntry('Pecs', 'Dips', '16/05', '15/10x12/20x10'),
  HistoryEntry('Pecs', 'Dips', '30/06', '12/10/12/15x12'),
  HistoryEntry('Pecs', 'Fly vers le bas', '26/03', '10.2x12/14.7x12x3'),
  HistoryEntry('Pecs', 'Fly vers le bas', '13/04', '12.5x12/14.7x12/17x8'),
  HistoryEntry('Pecs', 'Fly vers le bas', '22/04', '14.7x10/14.7x12/12.5x12'),
  HistoryEntry('Pecs', 'Fly vers le bas', '29/04', '12.5x15/14.7x12x2'),
  HistoryEntry('Pecs', 'Fly vers le bas', '08/05', '14.7x12x4'),
  HistoryEntry('Pecs', 'Fly vers le bas', '16/05', '14.7x13x2/17x8x2'),
  HistoryEntry('Pecs', 'Fly vers le bas', '11/06', '14.7x12x2/17x8/14.7x15'),
  HistoryEntry('Pecs', 'Fly vers le bas', '30/06', '12.5x12/14.7x12'),
  HistoryEntry('Pecs', 'Fly vers le haut', '22/04', '5.7x12/5.7x14/7.9x10x2'),
  // ----- Épaules -----
  HistoryEntry('Épaules', 'Shoulder press', '16/03', '23x15/32x12/36x8'),
  HistoryEntry('Épaules', 'Shoulder press', '24/03', '32x12/36x12/41x10x2'),
  HistoryEntry('Épaules', 'Shoulder press', '04/04', '32x15/41x10x2'),
  HistoryEntry('Épaules', 'Shoulder press', '11/04', '27x15/36x12/41x8/41x10'),
  HistoryEntry('Épaules', 'Shoulder press', '19/04', '36x12/41x10/45x8/45x6'),
  HistoryEntry('Épaules', 'Shoulder press', '05/05', '36x12/41x12x3'),
  HistoryEntry('Épaules', 'Shoulder press', '15/05', '36x12/41x12/45x8/41x8'),
  HistoryEntry('Épaules', 'Shoulder press', '03/06', '36x12/41x10/45x7/41x8'),
  HistoryEntry('Épaules', 'Shoulder press', '10/06', '36x12/41x12/45x8/41x10'),
  HistoryEntry('Épaules', 'Shoulder press', '18/06', '41x12/45x10/45x8/41x10'),
  HistoryEntry('Épaules', 'Shoulder press', '25/06', '36x12/41x12/45x12/45x9'),
  HistoryEntry(
      'Épaules', 'Shoulder press', '08/07', '32x12/36x13/41x12/45x8/41x12'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '24/03', '5.7x10/5.7x12x2'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '11/04', '5.7x12x2/7.9x8'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '19/04', '5.7x12/7.9x8/5.7x12'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '05/05', '9x12x2/11.3x10x2'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '15/05', '7.9x8/5.7x12x3'),
  HistoryEntry('Épaules', 'Élévations latérales poulie', '03/06', '5.7x10x4'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '10/06', '5.7x10/5.7x12/5.7x10'),
  HistoryEntry(
      'Épaules', 'Élévations latérales poulie', '18/06', '5.7x8x2/5.7x10'),
  HistoryEntry('Épaules', 'Élévations latérales poulie', '25/06', '5.7x12x4'),
  HistoryEntry('Épaules', 'Élévations latérales poulie', '08/07', '5.7x12x4'),
  HistoryEntry('Épaules', 'Oiseau', '24/03', '6x12/8x15/10x8x2'),
  HistoryEntry('Épaules', 'Oiseau', '11/04', '6x12/8x12'),
  HistoryEntry('Épaules', 'Oiseau', '19/04', '6x15/8x12x3'),
  HistoryEntry('Épaules', 'Oiseau', '05/05', '8x13x2'),
  HistoryEntry('Épaules', 'Oiseau', '15/05', '8x13x2'),
  HistoryEntry('Épaules', 'Oiseau', '03/06', '8x12x4'),
  HistoryEntry('Épaules', 'Oiseau', '10/06', '10x12/10x10/8x12x2'),
  HistoryEntry('Épaules', 'Oiseau', '25/06', '8x12x4'),
  HistoryEntry('Épaules', 'Oiseau', '08/07', '8x12x4'),
  // ----- Triceps -----
  HistoryEntry('Triceps', 'Triceps vers le bas', '29/03', '41x12x2/45x8x2'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '01/04', '41x10/43.3x10x2'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '07/04', '27x10/23x10x3',
      note: 'Pas la même poulie'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '13/04', '36x12/41x8x3'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '24/04', '36x12x3'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '05/05', '36x12/41x10x3'),
  HistoryEntry(
      'Triceps', 'Triceps vers le bas', '12/05', '38.3x12/41x12x2/43.3x8'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '20/05', '41x12/43.3x10x3'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '04/06', '41x12/43.3x10x3'),
  HistoryEntry(
      'Triceps', 'Triceps vers le bas', '10/06', '41x12/43.3x12/45x8x2'),
  HistoryEntry('Triceps', 'Triceps vers le bas', '18/06', '41x10x2/43.3x8x2'),
  HistoryEntry(
      'Triceps', 'Triceps vers le bas', '06/07', '23x15/25.3x8/25.3x10x2',
      note: 'Pas la même machine'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '17/03', '23x10'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '29/03', '23x10x2/27x8/27x10'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '01/04', '27x10x2/29.3x10'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '07/04', '27x12/32x10'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '13/04', '27x12/32x10x3'),
  HistoryEntry(
      'Triceps', 'Triceps vers le haut', '24/04', '32x10/27x10/27x12x2'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '04/05', '27x10x2/32x10x2'),
  HistoryEntry(
      'Triceps', 'Triceps vers le haut', '12/05', '32x12/32x11/34.3x10x2'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '20/05', '34.3x12x3'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '04/06', '34.3x12x2/32x12x3'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '10/06', '32x10x2'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '18/06', '32x12/34.3x12x3'),
  HistoryEntry('Triceps', 'Triceps vers le haut', '25/06', '32x12x2'),
  // ----- Dos -----
  HistoryEntry('Dos', 'Traction', '20/03', '12x4'),
  HistoryEntry('Dos', 'Traction', '02/04', '12x2/10'),
  HistoryEntry('Dos', 'Traction', '09/04', '10/12/10'),
  HistoryEntry('Dos', 'Traction', '17/04', '10/12/10/10'),
  HistoryEntry('Dos', 'Traction', '05/05', '10/10x10/15x8/10x8'),
  HistoryEntry('Dos', 'Traction', '14/05', '10/10x10x3'),
  HistoryEntry('Dos', 'Traction', '07/06', '12/10x10/15x6'),
  HistoryEntry('Dos', 'Traction', '15/06', '10/10/15x8/15x7/10x8'),
  HistoryEntry('Dos', 'Traction', '23/06', '12/10x8x3'),
  HistoryEntry('Dos', 'Traction', '05/07', '12/15x8x2/10x10'),
  HistoryEntry('Dos', 'Papillons dos', '20/03', '32x12/45x12x2/52x10x2'),
  HistoryEntry('Dos', 'Tirage horizontal', '20/03', '39x12/52x12/59x10x2'),
  HistoryEntry('Dos', 'Tirage horizontal', '02/04', '52x12/59x12x3'),
  HistoryEntry(
      'Dos', 'Tirage horizontal', '17/04', '52x12/59x12/61.3x12/66x8'),
  HistoryEntry('Dos', 'Tirage horizontal', '05/05', '59x12x2/61.3x12/66x10'),
  HistoryEntry('Dos', 'Tirage horizontal', '14/05', '59x12/61.3x12/66x10x2'),
  HistoryEntry(
      'Dos', 'Tirage horizontal', '07/06', '59x12/61.3x12/66x9/66x10'),
  HistoryEntry('Dos', 'Tirage horizontal', '15/06', '61.3x12/68.3x10x2/66x10'),
  HistoryEntry('Dos', 'Tirage horizontal', '23/06', '59x12/66x10x3'),
  HistoryEntry('Dos', 'Tirage horizontal', '05/07', '52x10/59x12/66x10x2'),
  HistoryEntry('Dos', 'Rowing barre', '02/04', '20x12x2/25x8'),
  HistoryEntry('Dos', 'Rowing barre', '09/04', '20x12/25x12'),
  HistoryEntry('Dos', 'Rowing barre', '17/04', '20x15/25x12/30x8'),
  HistoryEntry('Dos', 'Rowing barre', '05/05', '25x12x4'),
  HistoryEntry('Dos', 'Rowing barre', '07/06', '25x12x4'),
  HistoryEntry('Dos', 'Rowing barre', '15/06', '10x15/20x10/25x12x3'),
  HistoryEntry('Dos', 'Rowing barre', '23/06', '20x12/25x12/30x8'),
  HistoryEntry('Dos', 'Rowing barre', '05/07', '25x12x2/30x10x2'),
  HistoryEntry('Dos', 'Tirage bûcheron', '14/05', '16x15/20x15/22x15'),
  // ----- Biceps -----
  HistoryEntry('Biceps', 'Curl pupitre', '16/03', '10x12x2/12.5x10x2'),
  HistoryEntry('Biceps', 'Curl pupitre', '24/03', '10x15/15x8x3'),
  HistoryEntry('Biceps', 'Curl pupitre', '04/04', '10x15/12.5x11/12.5x10x2'),
  HistoryEntry('Biceps', 'Curl pupitre', '08/04', '12.5x12/15x8x2'),
  HistoryEntry('Biceps', 'Curl pupitre', '14/04', '10x12/15x8x3'),
  HistoryEntry('Biceps', 'Curl pupitre', '23/04', '12.5x10'),
  HistoryEntry('Biceps', 'Curl pupitre', '30/04', '10x13/15x9/15x8x2'),
  HistoryEntry('Biceps', 'Curl pupitre', '09/05', '12.5x12/15x8x3'),
  HistoryEntry(
      'Biceps', 'Curl pupitre', '20/05', '10x12/12.5x12/15x10x2/15x8'),
  HistoryEntry('Biceps', 'Curl pupitre', '05/06', '10x12/15x10/15x9/15x10'),
  HistoryEntry('Biceps', 'Curl pupitre', '12/06', '10x12/15x10x2/15x9'),
  HistoryEntry('Biceps', 'Curl pupitre', '21/06', '10x12/15x10x2/15x8'),
  HistoryEntry('Biceps', 'Curl pupitre', '02/07', '10x12/15x10x2'),
  HistoryEntry('Biceps', 'Curl marteau banc incliné', '16/03', '10x10x4'),
  HistoryEntry('Biceps', 'Curl marteau banc incliné', '24/03', '8x12/8x15/10x10'),
  HistoryEntry('Biceps', 'Curl marteau banc incliné', '04/04', '8x12/10x10x3'),
  HistoryEntry(
      'Biceps', 'Curl marteau banc incliné', '14/04', '8x12/10x10x2/10x12'),
  HistoryEntry('Biceps', 'Curl marteau banc incliné', '23/04', '8x12x3'),
  HistoryEntry(
      'Biceps', 'Curl marteau banc incliné', '20/05', '8x12/10x10/10x12x2'),
  HistoryEntry(
      'Biceps', 'Curl marteau banc incliné', '05/06', '8x12/10x12x2/12x10x2'),
  HistoryEntry(
      'Biceps', 'Curl marteau banc incliné', '12/06', '10x12/12x10x2/12x8'),
  HistoryEntry('Biceps', 'Curl marteau banc incliné', '21/06', '10x12/12x10x3'),
  HistoryEntry('Biceps', 'Curl marteau banc incliné', '02/07', '12x10x4'),
  HistoryEntry('Biceps', 'Curl marteau', '04/04', '8x12/10x12/12x12'),
  HistoryEntry('Biceps', 'Curl marteau', '14/04', '12x12x3'),
  HistoryEntry('Biceps', 'Curl marteau', '23/04', '12x10/12x12x2'),
  HistoryEntry('Biceps', 'Curl marteau', '30/04', '10x15/12x12x2'),
  HistoryEntry('Biceps', 'Curl marteau', '09/05', '12x13/12x15/14x10x2'),
  HistoryEntry('Biceps', 'Curl marteau', '20/05', '12x12/12.5x12x2'),
  HistoryEntry('Biceps', 'Curl marteau', '05/06', '12x12x2/14x10x2'),
  HistoryEntry('Biceps', 'Curl marteau', '12/06', '12x12x2/14x10'),
  HistoryEntry('Biceps', 'Curl marteau', '21/06', '12x12x2/14x8/14x10'),
  HistoryEntry('Biceps', 'Curl marteau', '02/07', '12x10/12x12'),
  HistoryEntry('Biceps', 'Curl poulie', '08/04', '41x12x3'),
  HistoryEntry('Biceps', 'Curl poulie', '09/05', '41x12/43.3x10x3'),
  HistoryEntry('Biceps', 'Tractions supination', '08/04', '10'),
  HistoryEntry('Biceps', 'Tractions supination', '14/04', '10/10/10'),
  HistoryEntry('Biceps', 'Tractions supination', '23/04', '12/12/12'),
  HistoryEntry('Biceps', 'Tractions supination', '30/04', '10/10/10'),
  // ----- Bas du corps -----
  HistoryEntry('Bas du corps', 'Squat', '02/05', '30x12/45x8/45x10x2'),
  HistoryEntry('Bas du corps', 'Squat', '08/06', '30x12/40x12/45x10/50x8'),
  HistoryEntry('Bas du corps', 'Squat', '22/06', '30x12/40x12/50x8x2'),
  HistoryEntry('Bas du corps', 'Presse à cuisses', '19/03', '30x10/40x10x3'),
  HistoryEntry('Bas du corps', 'Presse à cuisses', '27/03', '40x10/45x10x2'),
  HistoryEntry('Bas du corps', 'Presse à cuisses', '11/04', '35x12/45x10x2'),
  HistoryEntry(
      'Bas du corps', 'Presse à cuisses', '16/04', '30x12/40x12/50x10x2'),
  HistoryEntry('Bas du corps', 'Presse à cuisses', '10/05', '50x10x3'),
  HistoryEntry('Bas du corps', 'Presse à cuisses', '01/06', '40x10/50x10x3'),
  HistoryEntry('Bas du corps', 'Mollets debout', '19/03', '20x12/30x10x3'),
  HistoryEntry('Bas du corps', 'Mollets debout', '27/03', '30x10x4'),
  HistoryEntry('Bas du corps', 'Mollets debout', '11/04', '25x12x3'),
  HistoryEntry(
      'Bas du corps', 'Mollets debout', '16/04', '25x12/30x10/30x12x2'),
  HistoryEntry('Bas du corps', 'Mollets debout', '02/05', '30x12x2/40x9x2'),
  HistoryEntry('Bas du corps', 'Mollets debout', '10/05', '40x10'),
  HistoryEntry('Bas du corps', 'Mollets debout', '19/05', '40x12x4'),
  HistoryEntry('Bas du corps', 'Mollets debout', '01/06', '40x10x2'),
  HistoryEntry('Bas du corps', 'Mollets debout', '21/06', '35x10/40x10x3'),
  HistoryEntry('Bas du corps', 'Leg curl', '19/03', '50x10/57x10/63x8'),
  HistoryEntry('Bas du corps', 'Leg curl', '19/05', '50x12/57x12/63x8'),
  HistoryEntry('Bas du corps', 'Leg curl', '22/06', '57x12/63x12/70x8/70x10'),
  HistoryEntry('Bas du corps', 'Leg extension', '19/03', '50x10/57x8/63x8'),
  HistoryEntry('Bas du corps', 'Leg extension', '19/05', '50x12/57x12/63x12'),
  HistoryEntry('Bas du corps', 'Leg extension', '22/06', '57x12/63x12/70x10x2'),
  HistoryEntry('Bas du corps', 'Hack squat', '27/03', '20x10x4'),
  HistoryEntry('Bas du corps', 'Hack squat', '16/04', '35x3'),
  HistoryEntry('Bas du corps', 'Hack squat', '10/05', '30x10x2/32.5x10x2'),
  HistoryEntry('Bas du corps', 'Hack squat', '19/05', '40x8x4'),
  HistoryEntry('Bas du corps', 'Hack squat', '01/06', '35x10x2/40x8x2'),
  HistoryEntry(
      'Bas du corps', 'Leg curl allongé', '27/03', '14x12/36x15/41x10x2'),
  HistoryEntry('Bas du corps', 'Fentes bulgares', '16/04', '10x10'),
  HistoryEntry(
      'Bas du corps', 'Fentes bulgares', '02/05', '10x12x2/12x10/12x12'),
  HistoryEntry('Bas du corps', 'Fentes bulgares', '08/06', '12x12x3'),
  HistoryEntry('Bas du corps', 'Fentes bulgares', '22/06', '12x12'),
];
