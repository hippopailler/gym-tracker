import 'package:flutter/material.dart';

/// Couleurs d'accent disponibles, choisies depuis l'accueil.
enum AppAccent {
  orange('orange', 'Orange', Color(0xFFFF6B2C), Color(0xFFFFA36C),
      Color(0xFFE05314)),
  violet('violet', 'Violet', Color(0xFF8B5CF6), Color(0xFFB79CFA),
      Color(0xFF6D28D9)),
  vert('vert', 'Vert', Color(0xFF22C55E), Color(0xFF7BE3A2),
      Color(0xFF15803D)),
  bleu('bleu', 'Bleu', Color(0xFF3B82F6), Color(0xFF8AB4F8),
      Color(0xFF1D4ED8));

  const AppAccent(
      this.slug, this.label, this.accent, this.secondary, this.lightPrimary);

  /// Identifiant stable persisté dans les réglages.
  final String slug;
  final String label;

  /// Couleur principale (thème sombre).
  final Color accent;
  final Color secondary;

  /// Couleur principale assombrie pour le thème clair (contraste).
  final Color lightPrimary;

  static AppAccent fromSlug(String? slug) => AppAccent.values
      .firstWhere((a) => a.slug == slug, orElse: () => AppAccent.orange);
}

/// Thème de l'application : Material 3, accent au choix (orange par défaut),
/// sombre par défaut avec un thème clair complet.
class AppTheme {
  AppTheme._();

  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF171A21);

  /// Style pour les gros chiffres de performance (poids, chrono...).
  static const List<FontFeature> tabularFigures = [FontFeature.tabularFigures()];

  static ThemeData dark(AppAccent accent) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent.accent,
      brightness: Brightness.dark,
    ).copyWith(
      primary: accent.accent,
      onPrimary: Colors.white,
      secondary: accent.secondary,
      surface: darkSurface,
    );
    return _base(scheme).copyWith(
      scaffoldBackgroundColor: darkBackground,
    );
  }

  static ThemeData light(AppAccent accent) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent.accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: accent.lightPrimary,
      onPrimary: Colors.white,
    );
    return _base(scheme).copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7F5F2),
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: isDark ? darkBackground : const Color(0xFFF7F5F2),
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 1,
        color: isDark ? darkSurface : Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: isDark
              ? BorderSide(color: Colors.white.withValues(alpha: 0.06))
              : BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? darkSurface : Colors.white,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 68,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide.none,
        backgroundColor: scheme.primary.withValues(alpha: 0.12),
        labelStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.onSurface.withValues(alpha: 0.08),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

/// Style réutilisable pour les chiffres de performance.
TextStyle numberStyle(BuildContext context,
    {double size = 28, FontWeight weight = FontWeight.w800, Color? color}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    fontFeatures: AppTheme.tabularFigures,
    letterSpacing: -0.5,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );
}
