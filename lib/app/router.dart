import 'package:go_router/go_router.dart';

import '../features/task_timer/presentation/task_page.dart';
import '../features/works/presentation/work_details_page.dart';
import '../features/works/presentation/works_controller.dart';
import '../features/works/presentation/works_list_page.dart';

GoRouter buildRouter(WorksController works) => GoRouter(
  initialLocation: '/works',
  routes: [
    GoRoute(
      path: '/works',
      builder: (_, __) => WorksListPage(),
      routes: [
        GoRoute(
          path: ':workId',
          builder: (ctx, st) => WorkDetailsPage(
            workId: st.pathParameters['workId']!,
          ),
          routes: [
            GoRoute(
              path: 'tasks/:taskId',
              builder: (ctx, st) => TaskPage(
                workId: st.pathParameters['workId']!,
                taskId: st.pathParameters['taskId']!,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
