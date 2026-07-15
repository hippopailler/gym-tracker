import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import '../../core/providers.dart';
import '../../data/export/data_export.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _exporting = false;
  bool _importing = false;

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final service = ref.read(exportServiceProvider);
      final export = await service.createExport();
      final jsonString = export.toJsonString();
      final fileName =
          'gym-export-${DateTime.now().toIso8601String().split('T').first}.json';

      // Partager le fichier
      await share_plus.Share.share(
        jsonString,
        subject: fileName,
      );
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export réussi · Partage initié'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'export : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _import() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Importer un export JSON',
      );

      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.first.path!);
      final jsonString = await file.readAsString();
      final export = DataExport.fromJsonString(jsonString);

      if (export == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fichier JSON invalide')),
          );
        }
        return;
      }

      // Confirmer l'import
      final customCount = export.exercises
          .where((e) => (e as Map<String, dynamic>)['isCustom'] == true)
          .length;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Importer les données ?'),
          content: Text(
            'Cela va importer ${export.sessions.length} séances, '
            '${export.templates.length} templates et '
            '$customCount exercices personnalisés.',
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

      if (confirm != true || !mounted) return;

      setState(() => _importing = true);

      final database = ref.read(databaseProvider);
      await DataImporter.importData(database, export);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Import réussi'),
            duration: Duration(seconds: 2),
          ),
        );
        // Invalider les providers pour forcer la recharge
        ref.invalidate(exercisesProvider);
        ref.invalidate(templatesProvider);
        ref.invalidate(sessionSummariesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'import : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const SizedBox(height: 8),
          const Text(
            'Données',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exporter mes données',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Télécharge un fichier JSON contenant toutes tes '
                    'séances, templates et exercices. Indispensable avant '
                    'de changer d\'app ou de téléphone.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: _exporting ? null : _export,
                    icon: const Icon(Icons.download),
                    label: const Text('Exporter'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Importer des données',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Charge un fichier d\'export JSON précédent. Les '
                    'séances, templates et exercices importés s\'ajoutent '
                    'aux données existantes.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: _importing ? null : _import,
                    icon: const Icon(Icons.upload),
                    label: const Text('Importer'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
