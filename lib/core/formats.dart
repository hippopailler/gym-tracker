import 'package:intl/intl.dart';

final NumberFormat _kgFormat = NumberFormat('#,##0.##', 'fr_FR');
final NumberFormat _intFormat = NumberFormat('#,##0', 'fr_FR');

/// « 62,5 kg »
String formatKg(double value) => '${_kgFormat.format(value)} kg';

/// « 1 240 kg » pour les gros volumes.
String formatVolume(double value) => '${_intFormat.format(value)} kg';

/// « 2 500 m » ou « 12,3 km » pour les distances cardio.
String formatDistance(double meters) => meters >= 10000
    ? '${_kgFormat.format(meters / 1000)} km'
    : '${_intFormat.format(meters)} m';

/// « 02:15 » pour le chrono de repos.
String formatTimer(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// « 1 h 12 min » ou « 45 min » pour la durée d'une séance.
String formatDuration(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  if (h > 0) return '$h h ${m.toString().padLeft(2, '0')} min';
  if (m > 0) return '$m min';
  return '$seconds s';
}

/// « samedi 12 juillet »
String formatDayFull(DateTime date) =>
    DateFormat('EEEE d MMMM', 'fr_FR').format(date);

/// « 12 juil. 2026 »
String formatDateShort(DateTime date) =>
    DateFormat('d MMM yyyy', 'fr_FR').format(date);

/// « 12/07 »
String formatDayMonth(DateTime date) => DateFormat('dd/MM').format(date);

/// « 14:32 »
String formatTime(DateTime date) => DateFormat('HH:mm').format(date);

/// « juillet 2026 »
String formatMonthYear(DateTime date) =>
    DateFormat('MMMM yyyy', 'fr_FR').format(date);

/// Clé de jour (minuit) pour grouper par date.
DateTime dayKey(DateTime date) => DateTime(date.year, date.month, date.day);

extension StringCap on String {
  String capitalized() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
