import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Générateur des sources d'icône de l'application (haltère orange sur fond
/// sombre, assorti au thème). À relancer uniquement pour changer le design :
///
///   flutter test tool/generate_icons_test.dart
///   dart run flutter_launcher_icons
///
/// Produit dans assets/icon/ : icon.png (icône pleine), icon_foreground.png
/// (adaptive icon, contenu dans la zone sûre) et icon_monochrome.png
/// (icône thémée Android 13+).
const _accent = Color(0xFFFF6B2C);
const _bar = Color(0xFFF3EEE8);
const _background = Color(0xFF0F1115);

void _drawDumbbell(
  Canvas canvas,
  double size, {
  required Color plateColor,
  required Color barColor,
  required double scale,
}) {
  canvas.save();
  canvas.translate(size / 2, size / 2);
  canvas.rotate(-45 * 3.1415926535 / 180);
  canvas.scale(scale * size / 1024);

  final barPaint = Paint()
    ..color = barColor
    ..isAntiAlias = true;
  final platePaint = Paint()
    ..color = plateColor
    ..isAntiAlias = true;

  // Barre avec embouts d'axe dépassant franchement des plaques.
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 756, height: 64),
      const Radius.circular(32),
    ),
    barPaint,
  );
  // Deux plaques de chaque côté (l'intérieure plus grande).
  for (final direction in const [-1.0, 1.0]) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(direction * 190, 0), width: 88, height: 352),
        const Radius.circular(30),
      ),
      platePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(direction * 294, 0), width: 88, height: 258),
        const Radius.circular(30),
      ),
      platePaint,
    );
  }
  canvas.restore();
}

Future<ui.Image> _render(int size, void Function(Canvas canvas) draw) {
  final recorder = ui.PictureRecorder();
  draw(Canvas(recorder));
  return recorder.endRecording().toImage(size, size);
}

Future<void> _writePng(String path, ui.Image image) async {
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(path);
  await file.create(recursive: true);
  await file.writeAsBytes(data!.buffer.asUint8List());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('génère les sources d\'icône dans assets/icon/', () async {
    const size = 1024;

    // Icône pleine (launchers sans adaptive icon, fiche store).
    final full = await _render(size, (canvas) {
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 1024, 1024),
        Paint()..color = _background,
      );
      canvas.drawCircle(
        const Offset(512, 512),
        470,
        Paint()
          ..shader = ui.Gradient.radial(
            const Offset(512, 512),
            470,
            [_accent.withValues(alpha: 0.22), _accent.withValues(alpha: 0)],
          ),
      );
      _drawDumbbell(canvas, 1024,
          plateColor: _accent, barColor: _bar, scale: 0.8);
    });
    await _writePng('assets/icon/icon.png', full);

    // Premier plan de l'adaptive icon : le contenu doit tenir dans la zone
    // sûre (~66 % du canevas), le launcher masque et anime le reste.
    final foreground = await _render(size, (canvas) {
      canvas.drawCircle(
        const Offset(512, 512),
        330,
        Paint()
          ..shader = ui.Gradient.radial(
            const Offset(512, 512),
            330,
            [_accent.withValues(alpha: 0.22), _accent.withValues(alpha: 0)],
          ),
      );
      _drawDumbbell(canvas, 1024,
          plateColor: _accent, barColor: _bar, scale: 0.52);
    });
    await _writePng('assets/icon/icon_foreground.png', foreground);

    // Icône monochrome (thème Material You, Android 13+).
    final monochrome = await _render(size, (canvas) {
      _drawDumbbell(canvas, 1024,
          plateColor: Colors.white, barColor: Colors.white, scale: 0.52);
    });
    await _writePng('assets/icon/icon_monochrome.png', monochrome);

    expect(File('assets/icon/icon.png').existsSync(), isTrue);
    expect(File('assets/icon/icon_foreground.png').existsSync(), isTrue);
    expect(File('assets/icon/icon_monochrome.png').existsSync(), isTrue);
  });
}
