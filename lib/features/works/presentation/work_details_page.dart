import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_no_cry/app/di/injection.dart';

import '../../../shared/presentation/format_duration.dart';
import 'works_controller.dart';

class WorkDetailsPage extends StatefulWidget {
  final String workId;
  const WorkDetailsPage({super.key, required this.workId});

  @override
  State<WorkDetailsPage> createState() => _WorkDetailsPageState();
}

class _WorkDetailsPageState extends State<WorkDetailsPage> {
   final WorksController c = getIt();

  Future<void> _createTask() async {
    final title = await _askText(title: 'Новая задача', hint: 'Название');
    if (title == null || title.trim().isEmpty) return;
    await c.createTask(widget.workId, title.trim());
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final work = c.findWork(widget.workId);
    if (work == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Работа')),
        body: const Center(child: Text('Работа не найдена')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(work.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: Text(formatDuration(work.total))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        itemCount: work.tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final t = work.tasks[i];
          return ListTile(
            title: Text(t.title),
            subtitle: Text('Время: ${formatDuration(t.spent)}'),
            onTap: () => context.go('/works/${work.id}/tasks/${t.id}'),
          );
        },
      ),
    );
  }

  Future<String?> _askText({required String title, required String hint}) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: hint),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Создать')),
        ],
      ),
    );
  }
}
