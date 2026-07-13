import '../../domain/models/template_models.dart';
import '../database/database.dart';

class TemplateRepository {
  TemplateRepository(this._db);

  final AppDatabase _db;

  Stream<List<TemplateWithExercises>> watchAll() =>
      _db.templateDao.watchAllWithExercises();

  Future<TemplateWithExercises?> getById(int id) =>
      _db.templateDao.getWithExercises(id);

  Future<int> save({
    int? id,
    required String name,
    required String description,
    required String tags,
    required List<TemplateExerciseDraft> items,
  }) {
    return _db.templateDao.saveTemplate(
      id: id,
      name: name,
      description: description,
      tags: tags,
      items: items,
    );
  }

  Future<int?> duplicate(int id) => _db.templateDao.duplicateTemplate(id);

  Future<void> delete(int id) => _db.templateDao.deleteTemplate(id);
}
