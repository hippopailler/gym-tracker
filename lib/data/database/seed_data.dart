/// Données de pré-remplissage de la base : catalogue d'exercices courants
/// (avec leurs groupes musculaires) et templates par défaut.
library;

class SeedExercise {
  const SeedExercise(
    this.name,
    this.muscles,
    this.equipment,
    this.restSeconds,
    this.description, {
    this.isDuration = false,
    this.isCardio = false,
  });

  final String name;
  final List<String> muscles;
  final String equipment;
  final int restSeconds;
  final String description;

  /// Vrai pour les exercices mesurés en secondes (planche…).
  final bool isDuration;

  /// Vrai pour les exercices cardio (durée + distance).
  final bool isCardio;
}

const List<SeedExercise> kSeedExercises = [
  // Pectoraux
  SeedExercise('Développé couché', ['pectoraux', 'triceps'], 'Barre', 120,
      'Allongé sur un banc, descendre la barre au niveau de la poitrine puis pousser.'),
  SeedExercise('Développé incliné haltères', ['pectoraux', 'epaules'],
      'Haltères', 120,
      'Banc incliné à 30-45°, pousser les haltères au-dessus de la poitrine.'),
  SeedExercise('Écarté à la poulie', ['pectoraux'], 'Poulie', 90,
      'Bras semi-tendus, ramener les poignées devant soi en contractant les pectoraux.'),
  SeedExercise('Dips', ['pectoraux', 'triceps'], 'Poids du corps', 120,
      'Aux barres parallèles, descendre en fléchissant les coudes puis remonter.'),
  SeedExercise('Pompes', ['pectoraux', 'triceps'], 'Poids du corps', 60,
      'Corps gainé, fléchir les bras jusqu\'à frôler le sol puis pousser.'),
  // Dos
  SeedExercise('Soulevé de terre', ['dos', 'jambes', 'fessiers'], 'Barre', 180,
      'Soulever la barre du sol jusqu\'à l\'extension complète des hanches, dos neutre.'),
  SeedExercise('Rowing barre', ['dos', 'biceps'], 'Barre', 120,
      'Buste penché, tirer la barre vers le bas des pectoraux en serrant les omoplates.'),
  SeedExercise('Traction', ['dos', 'biceps'], 'Poids du corps', 120,
      'Suspendu à la barre, tirer jusqu\'à passer le menton au-dessus.'),
  SeedExercise('Tirage vertical', ['dos', 'biceps'], 'Poulie', 90,
      'Tirer la barre vers le haut de la poitrine, coudes vers le bas.'),
  SeedExercise('Tirage horizontal', ['dos'], 'Poulie', 90,
      'Assis, tirer la poignée vers le nombril en gardant le dos droit.'),
  SeedExercise('Rowing haltère un bras', ['dos'], 'Haltères', 90,
      'Un genou sur le banc, tirer l\'haltère vers la hanche.'),
  // Épaules
  SeedExercise('Développé militaire', ['epaules', 'triceps'], 'Barre', 120,
      'Debout, pousser la barre des épaules jusqu\'au-dessus de la tête.'),
  SeedExercise('Élévations latérales', ['epaules'], 'Haltères', 60,
      'Bras légèrement fléchis, monter les haltères à l\'horizontale.'),
  SeedExercise('Élévations frontales', ['epaules'], 'Haltères', 60,
      'Monter les haltères devant soi jusqu\'à hauteur d\'épaules.'),
  SeedExercise('Oiseau', ['epaules', 'dos'], 'Haltères', 60,
      'Buste penché, écarter les haltères sur les côtés pour l\'arrière d\'épaule.'),
  SeedExercise('Face pull', ['epaules', 'dos'], 'Poulie', 60,
      'Tirer la corde vers le visage, coudes hauts, en ouvrant les épaules.'),
  // Biceps
  SeedExercise('Curl biceps', ['biceps'], 'Haltères', 90,
      'Coudes fixes le long du corps, fléchir les avant-bras.'),
  SeedExercise('Curl marteau', ['biceps', 'avant-bras'], 'Haltères', 90,
      'Prise neutre (paumes face à face), fléchir les avant-bras.'),
  SeedExercise('Curl à la barre', ['biceps'], 'Barre', 90,
      'Prise en supination, fléchir les avant-bras sans balancer le buste.'),
  // Triceps
  SeedExercise('Extension triceps', ['triceps'], 'Poulie', 90,
      'Coudes fixes, étendre les avant-bras vers le bas.'),
  SeedExercise('Barre au front', ['triceps'], 'Barre', 90,
      'Allongé, descendre la barre vers le front en ne pliant que les coudes.'),
  // Jambes / fessiers / mollets
  SeedExercise('Squat', ['jambes', 'fessiers'], 'Barre', 150,
      'Barre sur les trapèzes, descendre les hanches sous les genoux puis remonter.'),
  SeedExercise('Presse à cuisses', ['jambes', 'fessiers'], 'Machine', 120,
      'Pousser le chariot avec les jambes sans verrouiller les genoux.'),
  SeedExercise('Fentes', ['jambes', 'fessiers'], 'Haltères', 90,
      'Grand pas en avant, descendre le genou arrière vers le sol puis remonter.'),
  SeedExercise('Leg extension', ['jambes'], 'Machine', 90,
      'Assis, étendre les jambes contre la résistance.'),
  SeedExercise('Leg curl', ['jambes'], 'Machine', 90,
      'Fléchir les jambes contre la résistance pour cibler les ischios.'),
  SeedExercise('Soulevé de terre roumain', ['jambes', 'fessiers', 'dos'],
      'Barre', 120,
      'Jambes presque tendues, descendre la barre le long des cuisses, dos plat.'),
  SeedExercise('Hip thrust', ['fessiers'], 'Barre', 120,
      'Dos sur un banc, pousser les hanches vers le haut avec la barre sur le bassin.'),
  SeedExercise('Mollets debout', ['mollets'], 'Machine', 60,
      'Monter sur la pointe des pieds, redescendre lentement.'),
  // Abdominaux
  SeedExercise('Crunch', ['abdominaux'], 'Poids du corps', 45,
      'Allongé, enrouler le buste vers les genoux sans tirer sur la nuque.'),
  SeedExercise('Planche', ['abdominaux'], 'Poids du corps', 60,
      'En appui sur les avant-bras, corps gainé et aligné.',
      isDuration: true),
  SeedExercise('Relevés de jambes', ['abdominaux'], 'Poids du corps', 60,
      'Suspendu ou allongé, monter les jambes tendues sans balancer.'),
];

/// Exercices ajoutés au schéma v4 : machines/poulies de la salle,
/// street workout et cardio. Insérés par la migration v4 (et par le seed
/// des bases neuves) s'ils n'existent pas déjà.
const List<SeedExercise> kSeedExercisesV4 = [
  // Machines et poulies de la salle
  SeedExercise('Chest press', ['pectoraux', 'triceps'], 'Machine', 90,
      'Assis, pousser les poignées devant soi en contractant les pectoraux.'),
  SeedExercise('Papillons', ['pectoraux'], 'Machine', 90,
      'Pec deck : ramener les bras devant soi en serrant les pectoraux.'),
  SeedExercise('Fly vers le bas', ['pectoraux'], 'Poulie', 90,
      'Poulies hautes, ramener les poignées vers le bas et l\'avant.'),
  SeedExercise('Fly vers le haut', ['pectoraux', 'epaules'], 'Poulie', 90,
      'Poulies basses, monter les poignées devant soi en croisant.'),
  SeedExercise('Shoulder press', ['epaules', 'triceps'], 'Machine', 90,
      'Assis, pousser les poignées au-dessus de la tête.'),
  SeedExercise('Élévations latérales poulie', ['epaules'], 'Poulie', 60,
      'À la poulie basse, monter le bras à l\'horizontale sur le côté.'),
  SeedExercise('Élévations frontales poulie', ['epaules'], 'Poulie', 60,
      'À la poulie basse, monter la poignée devant soi à hauteur d\'épaule.'),
  SeedExercise('Triceps vers le bas', ['triceps'], 'Poulie', 90,
      'Poulie haute, coudes fixes, étendre les avant-bras vers le bas.'),
  SeedExercise('Triceps vers le haut', ['triceps'], 'Poulie', 90,
      'Extension au-dessus de la tête, coudes serrés.'),
  SeedExercise('Papillons dos', ['epaules', 'dos'], 'Machine', 90,
      'Pec deck inversé : écarter les bras vers l\'arrière.'),
  SeedExercise('Tirage bûcheron', ['dos'], 'Poulie', 90,
      'Tirage unilatéral à la poulie, buste gainé, coude le long du corps.'),
  SeedExercise('Curl pupitre', ['biceps'], 'Machine', 90,
      'Bras posés sur le pupitre, fléchir les avant-bras.'),
  SeedExercise('Curl marteau banc incliné', ['biceps', 'avant-bras'],
      'Haltères', 90,
      'Allongé sur banc incliné, curl en prise neutre, bras vers l\'arrière.'),
  SeedExercise('Curl poulie', ['biceps'], 'Poulie', 90,
      'À la poulie basse, coudes fixes, fléchir les avant-bras.'),
  SeedExercise('Tractions supination', ['biceps', 'dos'], 'Poids du corps',
      120,
      'Tractions en prise supination (paumes vers soi), biceps prioritaires.'),
  SeedExercise('Hack squat', ['jambes', 'fessiers'], 'Machine', 120,
      'Dos calé sur la machine inclinée, fléchir les jambes puis pousser.'),
  SeedExercise('Leg curl allongé', ['jambes'], 'Machine', 90,
      'Allongé sur le ventre, fléchir les jambes contre la résistance.'),
  SeedExercise('Fentes bulgares', ['jambes', 'fessiers'], 'Haltères', 90,
      'Pied arrière surélevé sur un banc, descendre sur la jambe avant.'),
  // Street workout
  SeedExercise('Muscle-up', ['dos', 'pectoraux', 'triceps'], 'Poids du corps',
      150,
      'Traction explosive puis passage au-dessus de la barre en dips.'),
  SeedExercise('Pistol squat', ['jambes', 'fessiers'], 'Poids du corps', 90,
      'Squat complet sur une jambe, l\'autre tendue devant soi.'),
  SeedExercise('Pompes en poirier', ['epaules', 'triceps'], 'Poids du corps',
      120,
      'En équilibre contre un mur, fléchir les bras jusqu\'au sol et pousser.'),
  SeedExercise('Pompes archer', ['pectoraux', 'triceps'], 'Poids du corps', 90,
      'Pompes en déportant le poids sur un bras, l\'autre tendu sur le côté.'),
  SeedExercise('Front lever', ['dos', 'abdominaux'], 'Poids du corps', 120,
      'Suspendu à la barre, corps tendu à l\'horizontale, tenir la position.',
      isDuration: true),
  SeedExercise('L-sit', ['abdominaux'], 'Poids du corps', 90,
      'En appui, jambes tendues à l\'horizontale, tenir la position.',
      isDuration: true),
  // Cardio (durée + distance)
  SeedExercise('Rameur', ['cardio', 'dos', 'jambes'], 'Machine', 60,
      'Tirage complet jambes-dos-bras, allure régulière.',
      isCardio: true),
  SeedExercise('Skieur', ['cardio', 'epaules', 'dos'], 'Machine', 60,
      'SkiErg : tirer les poignées de haut en bas comme en ski de fond.',
      isCardio: true),
  SeedExercise('Course', ['cardio', 'jambes'], 'Tapis / extérieur', 60,
      'Course sur tapis ou en extérieur.',
      isCardio: true),
];

/// Correspondance des anciens libellés (schéma v1, un seul groupe par
/// exercice) vers les slugs actuels — utilisée par la migration v1 → v2.
const Map<String, String> kLegacyLabelToSlug = {
  'Pectoraux': 'pectoraux',
  'Dos': 'dos',
  'Épaules': 'epaules',
  'Biceps': 'biceps',
  'Triceps': 'triceps',
  'Jambes': 'jambes',
  'Fessiers': 'fessiers',
  'Abdominaux': 'abdominaux',
  'Mollets': 'mollets',
};

class SeedTemplate {
  const SeedTemplate(this.name, this.description, this.tags, this.items);

  final String name;
  final String description;
  final String tags;

  /// (nom de l'exercice, séries, répétitions, repos en secondes)
  final List<(String, int, int, int)> items;
}

const List<SeedTemplate> kSeedTemplates = [
  SeedTemplate('Push', 'Pectoraux, épaules et triceps.', 'push,haut du corps', [
    ('Développé couché', 4, 8, 120),
    ('Développé militaire', 3, 10, 120),
    ('Élévations latérales', 3, 12, 60),
    ('Extension triceps', 3, 12, 90),
  ]),
  SeedTemplate('Pull', 'Dos et biceps.', 'pull,haut du corps', [
    ('Traction', 4, 8, 120),
    ('Rowing barre', 4, 10, 120),
    ('Curl biceps', 3, 12, 90),
  ]),
  SeedTemplate('Legs', 'Quadriceps, ischios et chaîne postérieure.', 'jambes', [
    ('Squat', 4, 8, 150),
    ('Presse à cuisses', 3, 12, 120),
    ('Soulevé de terre', 3, 6, 180),
  ]),
  SeedTemplate('Épaules', 'Séance ciblée épaules.', 'épaules,isolation', [
    ('Développé militaire', 4, 8, 120),
    ('Élévations latérales', 4, 15, 60),
    ('Oiseau', 3, 12, 60),
  ]),
  SeedTemplate(
      'Full body débutant',
      'Tout le corps sur une séance, idéal pour commencer.',
      'débutant,full body', [
    ('Squat', 3, 10, 120),
    ('Développé couché', 3, 10, 120),
    ('Rowing barre', 3, 10, 120),
    ('Développé militaire', 2, 12, 90),
    ('Curl biceps', 2, 12, 60),
  ]),
];

/// Templates des séances types réelles (reconstituées depuis l'historique
/// importé). Ajoutés par la migration v4 s'ils n'existent pas déjà.
const List<SeedTemplate> kSeedTemplatesV4 = [
  SeedTemplate('Pecs', 'Séance pectoraux machines et poulies.',
      'pecs,machines', [
    ('Chest press', 4, 10, 90),
    ('Papillons', 4, 12, 90),
    ('Dips', 4, 10, 120),
    ('Fly vers le bas', 3, 12, 90),
  ]),
  SeedTemplate('Épaules machine', 'Shoulder press et poulies.',
      'épaules,machines', [
    ('Shoulder press', 4, 12, 90),
    ('Élévations latérales poulie', 4, 12, 60),
    ('Oiseau', 4, 12, 60),
  ]),
  SeedTemplate('Triceps', 'Extensions à la poulie.', 'triceps,poulie', [
    ('Triceps vers le bas', 4, 10, 90),
    ('Triceps vers le haut', 3, 10, 90),
  ]),
  SeedTemplate('Dos', 'Tractions et tirages.', 'dos,pull', [
    ('Traction', 4, 10, 120),
    ('Tirage horizontal', 4, 12, 90),
    ('Rowing barre', 4, 12, 90),
  ]),
  SeedTemplate('Biceps', 'Curls pupitre, haltères et poulie.', 'biceps', [
    ('Curl pupitre', 4, 10, 90),
    ('Curl marteau banc incliné', 4, 10, 90),
    ('Curl marteau', 3, 12, 90),
  ]),
  SeedTemplate('Bas du corps', 'Quadriceps, ischios et mollets.', 'jambes', [
    ('Squat', 4, 10, 120),
    ('Presse à cuisses', 3, 10, 120),
    ('Leg extension', 3, 12, 90),
    ('Leg curl', 3, 12, 90),
    ('Mollets debout', 4, 10, 60),
  ]),
];
