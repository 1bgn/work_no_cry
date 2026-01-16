import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/injection.dart';
import '../../../shared/presentation/format_duration.dart';
import 'works_controller.dart';

class WorksListPage extends StatefulWidget {
  const WorksListPage({super.key});

  @override
  State<WorksListPage> createState() => _WorksListPageState();
}

class _WorksListPageState extends State<WorksListPage> {
  final WorksController c = getIt<WorksController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await c.load();
      if (mounted) setState(() {});
    });
  }

  Future<void> _createWork() async {
    final title = await _askText(title: 'Новая работа', hint: 'Название');
    if (title == null || title.trim().isEmpty) return;
    await c.createWork(title.trim());
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final works = c.works.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Работы'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text('Итого: ${formatDuration(c.totalSpent.value)}'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => context.go('/stats'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWork,
        child: const Icon(Icons.add),
      ),
      body: c.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: works.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final w = works[i];
          return ListTile(
            title: Text(w.title),
            subtitle: Text('Задач: ${w.tasks.length} • ${formatDuration(w.total)}'),
            onTap: () => context.go('/works/${w.id}'),
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
