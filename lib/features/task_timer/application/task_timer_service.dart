import 'package:injectable/injectable.dart';
import '../../works/application/works_service.dart';

@injectable
class TaskTimerService {
  final WorksService works;
  TaskTimerService(this.works);

  Future<void> addSpent({
    required String workId,
    required String taskId,
    required int addMs,
  }) async {
    await works.addSpent(workId: workId, taskId: taskId, addMs: addMs);
  }
}
