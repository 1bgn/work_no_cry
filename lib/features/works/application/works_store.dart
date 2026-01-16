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

class TaskSession {
  final String id;
  final int startedAtMs; // unix ms
  final int durationMs;
  final String? note;

  const TaskSession({
    required this.id,
    required this.startedAtMs,
    required this.durationMs,
    this.note,
  });

  Duration get duration => Duration(milliseconds: durationMs);

  Map<String, dynamic> toJson() => {
    'id': id,
    'startedAtMs': startedAtMs,
    'durationMs': durationMs,
    'note': note,
  };

  static TaskSession fromJson(Map<String, dynamic> j) => TaskSession(
    id: j['id'] as String,
    startedAtMs: (j['startedAtMs'] as num).toInt(),
    durationMs: (j['durationMs'] as num).toInt(),
    note: j['note'] as String?,
  );
}

class Task {
  final String id;
  final String title;

  /// Для быстрого вывода суммарного времени (сохраняем явно).
  final int spentMs;

  /// История сессий таймера.
  final List<TaskSession> sessions;

  const Task({
    required this.id,
    required this.title,
    required this.spentMs,
    required this.sessions,
  });

  Duration get spent => Duration(milliseconds: spentMs);

  Task copyWith({
    String? title,
    int? spentMs,
    List<TaskSession>? sessions,
  }) =>
      Task(
        id: id,
        title: title ?? this.title,
        spentMs: spentMs ?? this.spentMs,
        sessions: sessions ?? this.sessions,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'spentMs': spentMs,
    'sessions': sessions.map((s) => s.toJson()).toList(),
  };

  static Task fromJson(Map<String, dynamic> j) => Task(
    id: j['id'] as String,
    title: j['title'] as String,
    spentMs: (j['spentMs'] as num).toInt(),
    // backward-compatible: если старые данные без sessions
    sessions: ((j['sessions'] as List<dynamic>?) ?? const [])
        .map((e) => TaskSession.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
