import 'package:flutter/material.dart';

/// Catalogue des groupes musculaires : identifiant stable (slug) stocké en
/// base, libellé et icône pour l'affichage.
class MuscleGroup {
  const MuscleGroup({
    required this.slug,
    required this.label,
    required this.icon,
  });

  final String slug;
  final String label;
  final IconData icon;
}

const List<MuscleGroup> kMuscleGroups = [
  MuscleGroup(slug: 'pectoraux', label: 'Pectoraux', icon: Icons.fitness_center),
  MuscleGroup(slug: 'dos', label: 'Dos', icon: Icons.rowing),
  MuscleGroup(slug: 'epaules', label: 'Épaules', icon: Icons.sports_gymnastics),
  MuscleGroup(slug: 'biceps', label: 'Biceps', icon: Icons.sports_martial_arts),
  MuscleGroup(slug: 'triceps', label: 'Triceps', icon: Icons.sports_mma),
  MuscleGroup(slug: 'abdominaux', label: 'Abdominaux', icon: Icons.grid_on),
  MuscleGroup(slug: 'jambes', label: 'Jambes', icon: Icons.directions_run),
  MuscleGroup(slug: 'fessiers', label: 'Fessiers', icon: Icons.stairs),
  MuscleGroup(slug: 'mollets', label: 'Mollets', icon: Icons.directions_walk),
  MuscleGroup(slug: 'avant-bras', label: 'Avant-bras', icon: Icons.pan_tool),
];

/// Résout un slug vers son groupe ; les slugs inconnus (données importées ou
/// anciennes) restent affichables avec une icône générique.
MuscleGroup muscleGroupBySlug(String slug) {
  for (final group in kMuscleGroups) {
    if (group.slug == slug) return group;
  }
  return MuscleGroup(slug: slug, label: slug, icon: Icons.fitness_center);
}

/// Trie des slugs selon l'ordre du catalogue.
List<String> sortedMuscleSlugs(Iterable<String> slugs) {
  final order = {
    for (var i = 0; i < kMuscleGroups.length; i++) kMuscleGroups[i].slug: i,
  };
  final list = slugs.toSet().toList()
    ..sort((a, b) => (order[a] ?? 99).compareTo(order[b] ?? 99));
  return list;
}
