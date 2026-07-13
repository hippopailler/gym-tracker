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
  });

  final String name;
  final List<String> muscles;
  final String equipment;
  final int restSeconds;
  final String description;

  /// Vrai pour les exercices mesurés en secondes (planche…).
  final bool isDuration;
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
