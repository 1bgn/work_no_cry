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

  int? _startedAtMs;

  TaskTimerController(
      this._service, {
        required this.workId,
        required this.taskId,
      });

  void start() {
    if (isRunning.value) return;

    _startedAtMs ??= DateTime.now().millisecondsSinceEpoch;

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

  Future<int> stopAndSave({String? note}) async {
    _sw.stop();
    _timer?.cancel();
    _timer = null;

    final durationMs = _sw.elapsedMilliseconds;
    final startedAtMs = _startedAtMs ?? DateTime.now().millisecondsSinceEpoch;

    _sw.reset();
    _startedAtMs = null;

    isRunning.value = false;
    tickMs.value = 0;

    if (durationMs > 0) {
      await _service.addSession(
        workId: workId,
        taskId: taskId,
        startedAtMs: startedAtMs,
        durationMs: durationMs,
        note: note,
      );
    }

    return durationMs;
  }

  void dispose() {
    _timer?.cancel();
  }
}
