import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../app/di/injection.dart';
import '../../../shared/presentation/format_duration.dart';
import '../../works/presentation/works_controller.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final works = getIt<WorksController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: Watch((context) {
        final list = works.works.value;

        final total = works.totalSpent.value;

        final allTasks = <({String workTitle, String taskTitle, Duration spent})>[];
        for (final w in list) {
          for (final t in w.tasks) {
            allTasks.add((workTitle: w.title, taskTitle: t.title, spent: t.spent));
          }
        }
        allTasks.sort((a, b) => b.spent.compareTo(a.spent));
        final top = allTasks.take(5).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Итого: ${formatDuration(total)}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Text('По работам', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...list.map((w) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(w.title),
              trailing: Text(formatDuration(w.total)),
            )),

            const SizedBox(height: 16),
            Text('Топ задач', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (top.isEmpty)
              const Text('Нет данных')
            else
              ...top.map((x) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(x.taskTitle),
                subtitle: Text(x.workTitle),
                trailing: Text(formatDuration(x.spent)),
              )),
          ],
        );
      }),
    );
  }
}
