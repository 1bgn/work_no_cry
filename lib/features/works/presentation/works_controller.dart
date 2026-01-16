import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../application/works_service.dart';
import '../application/works_store.dart';

@lazySingleton
class WorksController {
  final WorksService _service;

  final works = signal<List<Work>>([]);
  final isLoading = signal(false);

  late final totalSpent = computed(() =>
      works.value.fold(Duration.zero, (a, w) => a + w.total));

  WorksController(this._service);
  Future<void> addSession({
    required String workId,
    required String taskId,
    required int startedAtMs,
    required int durationMs,
    String? note,
  }) async {
    works.value = await _service.addSession(
      workId: workId,
      taskId: taskId,
      startedAtMs: startedAtMs,
      durationMs: durationMs,
      note: note,
    );
  }

  Future<void> deleteSession({
    required String workId,
    required String taskId,
    required String sessionId,
  }) async {
    works.value = await _service.deleteSession(
      workId: workId,
      taskId: taskId,
      sessionId: sessionId,
    );
  }

  Future<void> load() async {
    isLoading.value = true;
    works.value = await _service.loadAll();
    isLoading.value = false;
  }

  Future<void> createWork(String title) async {
    works.value = await _service.createWork(title);
  }

  Future<void> createTask(String workId, String title) async {
    works.value = await _service.createTask(workId, title);
  }

  Work? findWork(String workId) {
    for (final w in works.value) {
      if (w.id == workId) return w;
    }
    return null;
  }

  Task? findTask(String workId, String taskId) {
    final w = findWork(workId);
    if (w == null) return null;
    for (final t in w.tasks) {
      if (t.id == taskId) return t;
    }
    return null;
  }
}
