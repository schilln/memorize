import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/editor/view_models/editor_viewmodel.dart';
import '../ui/editor/widgets/editor_screen.dart';
import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/home/widgets/home_screen.dart';
import 'routes.dart';

GoRouter get router => _router;

final GoRouter _router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen(
          viewModel: HomeViewModel(memoRepository: context.read()),
        );
      },
      routes: [
        GoRoute(
          path: Routes.editorRelative,
          builder: (context, state) {
            return EditorScreen(
              viewModel: EditorViewmodel(memoRepository: context.read()),
            );
          },
        ),
      ],
    ),
  ],
);
