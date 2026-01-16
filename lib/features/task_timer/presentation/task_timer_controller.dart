import 'dart:async';
import 'package:signals/signals.dart';

import '../application/task_timer_service.dart';

class TaskTimerController {
  final TaskTimerService _service;
  final String workId;
  final String taskId;

  final isRunning = signal(false);
  final tickMs = signal(0);

  final _sw = Stopwatch();
  Timer? _timer;

  TaskTimerController(
      this._service, {
        required this.workId,
        required this.taskId,
      });

  void start() {
    if (isRunning.value) return;
    isRunning.value = true;
    _sw.start();
    _timer ??= Timer.periodic(const Duration(milliseconds: 250), (_) {
      tickMs.value = _sw.elapsedMilliseconds;
    });
  }

  void pause() {
    if (!isRunning.value) return;
    isRunning.value = false;
    _sw.stop();
  }

  Future<int> stopAndSave() async {
    // Сохраняем только то, что накопилось в Stopwatch.
    _sw.stop();
    _timer?.cancel();
    _timer = null;

    final addMs = _sw.elapsedMilliseconds;
    _sw.reset();

    isRunning.value = false;
    tickMs.value = 0;

    if (addMs > 0) {
      await _service.addSpent(workId: workId, taskId: taskId, addMs: addMs);
    }
    return addMs;
  }

  void dispose() {
    _timer?.cancel();
  }
}
