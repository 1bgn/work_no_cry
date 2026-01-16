import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../app/di/injection.dart';
import '../../../shared/presentation/format_duration.dart';
import '../../works/presentation/works_controller.dart';
import '../application/task_timer_service.dart';
import 'task_timer_controller.dart';

class TaskPage extends StatefulWidget {
  final String workId;
  final String taskId;

  const TaskPage({
    super.key,
    required this.workId,
    required this.taskId,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late final WorksController works = getIt<WorksController>();
  late final TaskTimerController timer = TaskTimerController(
    getIt<TaskTimerService>(),
    workId: widget.workId,
    taskId: widget.taskId,
  );

  @override
  void dispose() {
    timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final work = works.findWork(widget.workId);
    final task = works.findTask(widget.workId, widget.taskId);

    if (work == null || task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Задача')),
        body: const Center(child: Text('Задача не найдена')),
      );
    }

    final stored = task.spent;

    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Watch(
         (context) {
           final live = Duration(milliseconds: timer.tickMs.value);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Работа: ${work.title}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text('Накоплено (сохранено): ${formatDuration(stored)}'),
                const SizedBox(height: 8),
                Text('Текущая сессия: ${formatDuration(live)}'),
                const SizedBox(height: 8),
                Text('Будет итого: ${formatDuration(stored + live)}'),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          timer.start();
                          setState(() {});
                        },
                        child: const Text('Старт'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          timer.pause();
                          setState(() {});
                        },
                        child: const Text('Пауза'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await timer.stopAndSave();
                      await works.load(); // подтянуть обновлённое время в списки
                      if (mounted) setState(() {});
                    },
                    child: const Text('Стоп и сохранить'),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
