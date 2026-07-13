import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/database.dart';
import '../data/repositories/exercise_repository.dart';
import '../data/repositories/session_repository.dart';
import '../data/repositories/template_repository.dart';
import '../domain/models/active_session.dart';
import '../domain/models/exercise_models.dart';
import '../domain/models/progress_models.dart';
import '../domain/models/session_models.dart';
import '../domain/models/template_models.dart';
import '../domain/services/notification_service.dart';
import '../domain/services/progression_service.dart';
import '../domain/services/rest_timer_controller.dart';
import '../features/session/active_session_controller.dart';
import 'formats.dart';
import 'theme.dart';

// ----- Infrastructure -----

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Initialisé dans main() puis injecté via override.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('Injecté au démarrage'),
);

// ----- Services & repositories -----

final progressionServiceProvider =
    Provider<ProgressionService>((ref) => ProgressionService());

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepository(ref.watch(databaseProvider)),
);

final templateRepositoryProvider = Provider<TemplateRepository>(
  (ref) => TemplateRepository(ref.watch(databaseProvider)),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(
    ref.watch(databaseProvider),
    ref.watch(progressionServiceProvider),
  ),
);

// ----- Flux de données -----

final exercisesProvider = StreamProvider<List<ExerciseDetail>>(
  (ref) => ref.watch(exerciseRepositoryProvider).watchAll(),
);

final templatesProvider = StreamProvider<List<TemplateWithExercises>>(
  (ref) => ref.watch(templateRepositoryProvider).watchAll(),
);

final sessionSummariesProvider = StreamProvider<List<SessionSummary>>(
  (ref) => ref.watch(sessionRepositoryProvider).watchSummaries(),
);

/// Séances groupées par jour (clé = minuit) pour le calendrier.
final sessionsByDayProvider =
    Provider<AsyncValue<Map<DateTime, List<SessionSummary>>>>((ref) {
  return ref.watch(sessionSummariesProvider).whenData((summaries) {
    final byDay = <DateTime, List<SessionSummary>>{};
    for (final summary in summaries) {
      byDay.putIfAbsent(dayKey(summary.session.date), () => []).add(summary);
    }
    return byDay;
  });
});

final exerciseProgressProvider =
    StreamProvider.family<List<ExerciseProgressPoint>, int>(
  (ref, exerciseId) =>
      ref.watch(sessionRepositoryProvider).watchProgress(exerciseId),
);

/// Records par exercice pour la carte de l'accueil (mise à jour continue).
final prHighlightsProvider = StreamProvider<List<PrHighlight>>(
  (ref) => ref.watch(sessionRepositoryProvider).watchPrHighlights(),
);

/// Tableau des records datés d'un exercice (fiche exercice).
final exerciseRecordsProvider = FutureProvider.family<ExerciseRecords, int>(
  (ref, exerciseId) async {
    // Recharge la fiche quand l'historique de séances évolue.
    ref.watch(sessionSummariesProvider);
    return ref.read(sessionRepositoryProvider).exerciseRecords(exerciseId);
  },
);

// ----- État applicatif -----

final restTimerProvider =
    StateNotifierProvider<RestTimerController, RestTimerState>(
  (ref) => RestTimerController(ref.watch(notificationServiceProvider)),
);

final activeSessionProvider =
    StateNotifierProvider<ActiveSessionController, ActiveSessionState?>(
  (ref) => ActiveSessionController(ref),
);

/// Record battu lors d'une validation automatique (fin du chrono d'un
/// exercice en durée) : l'écran de séance l'écoute pour afficher la
/// célébration, puis le remet à null.
final prCelebrationProvider = StateProvider<PrCelebration?>((ref) => null);

/// Réglages d'apparence : mode sombre/clair et couleur d'accent,
/// persistés en base (table app_settings).
class ThemeSettings {
  const ThemeSettings({required this.mode, required this.accent});

  final ThemeMode mode;
  final AppAccent accent;
}

class ThemeSettingsController extends StateNotifier<ThemeSettings> {
  ThemeSettingsController(this._db)
      : super(const ThemeSettings(
            mode: ThemeMode.dark, accent: AppAccent.orange)) {
    _load();
  }

  final AppDatabase _db;

  Future<void> _load() async {
    final mode = await _db.getSetting('theme_mode');
    final accent = await _db.getSetting('theme_accent');
    if (!mounted) return;
    state = ThemeSettings(
      mode: mode == 'light' ? ThemeMode.light : ThemeMode.dark,
      accent: AppAccent.fromSlug(accent),
    );
  }

  void toggleMode() {
    final mode =
        state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = ThemeSettings(mode: mode, accent: state.accent);
    _db.setSetting('theme_mode', mode == ThemeMode.light ? 'light' : 'dark');
  }

  void setAccent(AppAccent accent) {
    state = ThemeSettings(mode: state.mode, accent: accent);
    _db.setSetting('theme_accent', accent.slug);
  }
}

/// Thème sombre orange par défaut, réglable depuis l'accueil.
final themeSettingsProvider =
    StateNotifierProvider<ThemeSettingsController, ThemeSettings>(
  (ref) => ThemeSettingsController(ref.watch(databaseProvider)),
);
