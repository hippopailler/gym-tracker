import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/providers.dart';
import '../../data/export/data_export.dart';

/// Paramètres : export/import JSON de toutes les données.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Écrit un vrai fichier .json et ouvre la feuille de partage
  /// (Drive, mail, Bluetooth…).
  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final export = await ref.read(exportServiceProvider).createExport();
      final date = DateTime.now().toIso8601String().split('T').first;
      final file =
          File('${(await getTemporaryDirectory()).path}/gym-export-$date.json');
      await file.writeAsString(export.toJsonString());
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'Export Gym Tracker $date',
      ));
    } catch (e) {
      _snack('Erreur d\'export : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    setState(() => _busy = true);
    try {
      final picked = await openFile(acceptedTypeGroups: const [
        XTypeGroup(label: 'Export JSON', extensions: ['json']),
      ]);
      if (picked == null) return;

      final export = DataExport.fromJsonString(await picked.readAsString());
      if (export == null) {
        _snack('Ce fichier n\'est pas un export Gym Tracker valide.');
        return;
      }

      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Importer les données ?'),
          content: Text(
            'Fichier du ${export.exportDate.split('T').first} : '
            '${export.sessions.length} séance(s), '
            '${export.templates.length} template(s). '
            'Les doublons (même nom et même date) seront ignorés.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Importer'),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      final bilan =
          await DataImporter.importData(ref.read(databaseProvider), export);
      _snack(
        '${bilan.importedSessions} séance(s) importée(s)'
        '${bilan.skippedSessions > 0 ? ', ${bilan.skippedSessions} doublon(s) ignoré(s)' : ''}'
        '${bilan.importedTemplates > 0 ? ', ${bilan.importedTemplates} template(s)' : ''}'
        '${bilan.createdExercises > 0 ? ', ${bilan.createdExercises} exercice(s) créé(s)' : ''}.',
      );
    } catch (e) {
      _snack('Erreur d\'import : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text(
            'Mes données',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Tout est stocké sur ce téléphone, rien ne part sur un serveur. '
            'Pense à exporter régulièrement (Drive, mail…) pour ne rien '
            'perdre en cas de casse ou de changement de téléphone.',
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.upload_file, color: scheme.primary),
              title: const Text('Exporter mes données',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text(
                  'Fichier .json complet : séances, templates, exercices'),
              onTap: _busy ? null : _export,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.download, color: scheme.primary),
              title: const Text('Importer un export',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text(
                  'Recharge un fichier exporté — les doublons sont ignorés'),
              onTap: _busy ? null : _import,
            ),
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
