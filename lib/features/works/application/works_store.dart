class Work {
  final String id;
  final String title;
  final List<Task> tasks;

  const Work({
    required this.id,
    required this.title,
    required this.tasks,
  });

  Duration get total => tasks.fold(Duration.zero, (a, t) => a + t.spent);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };

  static Work fromJson(Map<String, dynamic> j) => Work(
    id: j['id'] as String,
    title: j['title'] as String,
    tasks: (j['tasks'] as List<dynamic>)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Work copyWith({String? title, List<Task>? tasks}) => Work(
    id: id,
    title: title ?? this.title,
    tasks: tasks ?? this.tasks,
  );
}

class Task {
  final String id;
  final String title;
  final int spentMs;

  const Task({
    required this.id,
    required this.title,
    required this.spentMs,
  });

  Duration get spent => Duration(milliseconds: spentMs);

  Task copyWith({String? title, int? spentMs}) => Task(
    id: id,
    title: title ?? this.title,
    spentMs: spentMs ?? this.spentMs,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'spentMs': spentMs,
  };

  static Task fromJson(Map<String, dynamic> j) => Task(
    id: j['id'] as String,
    title: j['title'] as String,
    spentMs: (j['spentMs'] as num).toInt(),
  );
}
