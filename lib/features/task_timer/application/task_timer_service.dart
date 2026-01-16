import 'package:injectable/injectable.dart';
import '../../works/application/works_service.dart';

@injectable
class TaskTimerService {
  final WorksService works;
  TaskTimerService(this.works);

  Future<void> addSession({
    required String workId,
    required String taskId,
    required int startedAtMs,
    required int durationMs,
    String? note,
  }) async {
    await works.addSession(
      workId: workId,
      taskId: taskId,
      startedAtMs: startedAtMs,
      durationMs: durationMs,
      note: note,
    );
  }
}
