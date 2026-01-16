import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/works/presentation/works_controller.dart';
import '../router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  GoRouter router(WorksController works) => buildRouter(works);
}
