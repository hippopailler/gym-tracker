import 'package:flutter_test/flutter_test.dart';
import 'package:gym/data/database/database.dart';
import 'package:gym/domain/services/progression_service.dart';

SetEntry _set({required double weight, required int reps, int number = 1}) {
  return SetEntry(
    id: number,
    sessionExerciseId: 1,
    setNumber: number,
    weightKg: weight,
    reps: reps,
  );
}

void main() {
  final service = ProgressionService();

  group('suggest', () {
    test('retourne null sans historique', () {
      expect(service.suggest(lastSets: [], targetReps: 8), isNull);
    });

    test('suggère +2,5 kg quand toutes les séries atteignent l\'objectif', () {
      final suggestion = service.suggest(
        lastSets: [
          _set(weight: 60, reps: 8, number: 1),
          _set(weight: 60, reps: 8, number: 2),
          _set(weight: 60, reps: 9, number: 3),
        ],
        targetReps: 8,
      );
      expect(suggestion, isNotNull);
      expect(suggestion!.weightKg, 62.5);
      expect(suggestion.reps, 8);
      expect(suggestion.increased, isTrue);
    });

    test('suggère le même poids quand une série est sous l\'objectif', () {
      final suggestion = service.suggest(
        lastSets: [
          _set(weight: 60, reps: 8, number: 1),
          _set(weight: 60, reps: 6, number: 2),
        ],
        targetReps: 8,
      );
      expect(suggestion!.weightKg, 60);
      expect(suggestion.increased, isFalse);
    });
  });

  group('suggestDuration', () {
    SetEntry durationSet(int seconds, {int number = 1}) => SetEntry(
          id: number,
          sessionExerciseId: 1,
          setNumber: number,
          weightKg: 0,
          reps: 0,
          durationSeconds: seconds,
        );

    test('suggère +15 s quand la durée cible est tenue partout', () {
      final suggestion = service.suggestDuration(
        lastSets: [durationSet(60), durationSet(65, number: 2)],
        targetSeconds: 60,
      );
      expect(suggestion!.isDuration, isTrue);
      expect(suggestion.durationSeconds, 80); // 65 (max) + 15
      expect(suggestion.increased, isTrue);
    });

    test('suggère la durée max quand la cible n\'est pas tenue', () {
      final suggestion = service.suggestDuration(
        lastSets: [durationSet(60), durationSet(45, number: 2)],
        targetSeconds: 60,
      );
      expect(suggestion!.durationSeconds, 60);
      expect(suggestion.increased, isFalse);
    });
  });

  group('estimateOneRm (Epley)', () {
    test('poids × (1 + reps / 30)', () {
      expect(service.estimateOneRm(100, 10), closeTo(133.33, 0.01));
      expect(service.estimateOneRm(60, 1), closeTo(62, 0.01));
    });
  });

  group('totalVolume', () {
    test('somme des poids × répétitions', () {
      final volume = service.totalVolume([
        _set(weight: 60, reps: 8),
        _set(weight: 60, reps: 6),
      ]);
      expect(volume, 60 * 8 + 60 * 6);
    });
  });
}
