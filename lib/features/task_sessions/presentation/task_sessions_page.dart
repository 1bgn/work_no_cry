import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../app/di/injection.dart';
import '../../../shared/presentation/format_datetime.dart';
import '../../../shared/presentation/format_duration.dart';
import '../../works/presentation/works_controller.dart';

class TaskSessionsPage extends StatelessWidget {
  final String workId;
  final String taskId;

  const TaskSessionsPage({
    super.key,
    required this.workId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final works = getIt<WorksController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Сессии')),
      body: Watch((context) {
        final task = works.findTask(workId, taskId);
        if (task == null) {
          return const Center(child: Text('Задача не найдена'));
        }

        final sessions = [...task.sessions]
          ..sort((a, b) => b.startedAtMs.compareTo(a.startedAtMs));

        if (sessions.isEmpty) {
          return const Center(child: Text('Сессий пока нет'));
        }

        return ListView.separated(
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final s = sessions[i];
            return ListTile(
              title: Text(formatDateTimeMs(s.startedAtMs)),
              subtitle: Text('Длительность: ${formatDuration(s.duration)}'
                  '${(s.note == null || s.note!.trim().isEmpty) ? '' : '\n${s.note}'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await works.deleteSession(
                    workId: workId,
                    taskId: taskId,
                    sessionId: s.id,
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
