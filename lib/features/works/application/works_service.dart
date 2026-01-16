import 'package:injectable/injectable.dart';
import '../../../shared/persistence/prefs_json_store.dart';
import '../../../shared/types/ids.dart';
import 'works_store.dart';

@lazySingleton
class WorksService {
  static const _key = 'works_v1';

  final PrefsJsonStore jsonStore;

  WorksService({required this.jsonStore});

  Future<List<Work>> loadAll() async {
    final list = jsonStore.readJsonList(_key);
    return list.map((e) => Work.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Work>> _saveAll(List<Work> works) async {
    await jsonStore.writeJsonList(_key, works.map((w) => w.toJson()).toList());
    return works;
  }

  Future<List<Work>> createWork(String title) async {
    final works = await loadAll();
    final newWork = Work(id: newId(), title: title, tasks: const []);
    return _saveAll([...works, newWork]);
  }

  Future<List<Work>> createTask(String workId, String title) async {
    final works = await loadAll();
    final updated = works.map((w) {
      if (w.id != workId) return w;
      final t = Task(id: newId(), title: title, spentMs: 0);
      return w.copyWith(tasks: [...w.tasks, t]);
    }).toList();
    return _saveAll(updated);
  }

  Future<List<Work>> addSpent({
    required String workId,
    required String taskId,
    required int addMs,
  }) async {
    final works = await loadAll();
    final updated = works.map((w) {
      if (w.id != workId) return w;
      final tasks = w.tasks.map((t) {
        if (t.id != taskId) return t;
        return t.copyWith(spentMs: t.spentMs + addMs);
      }).toList();
      return w.copyWith(tasks: tasks);
    }).toList();
    return _saveAll(updated);
  }
}
