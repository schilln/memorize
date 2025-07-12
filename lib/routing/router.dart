import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/editor/view_models/editor_viewmodel.dart';
import '../ui/editor/widgets/editor_screen.dart';
import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/memorize/view_models/memorize_viewmodel.dart';
import '../ui/memorize/widgets/memorize_screen.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (final context, final state) {
        return HomeScreen(
          viewModel: HomeViewModel(memoRepository: context.read()),
        );
      },
      routes: [
        GoRoute(
          path: '${Routes.memorizerRelative}/:id',
          builder: (final context, final state) {
            final id = int.parse(state.pathParameters['id']!);
            final viewModel = MemorizeViewModel(
              id: id,
              memoRepository: context.read(),
            );
            return MemorizeScreen(viewModel: viewModel);
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.editor,
      builder: (final context, final state) {
        return EditorScreen(
          viewModel: EditorViewModel(memoRepository: context.read()),
        );
      },
      routes: [
        GoRoute(
          path: ':id',
          builder: (final context, final state) {
            final id = int.parse(state.pathParameters['id']!);
            final viewModel = EditorViewModel(memoRepository: context.read());
            viewModel.load.execute(id);
            return EditorScreen(viewModel: viewModel);
          },
        ),
      ],
    ),
  ],
);
