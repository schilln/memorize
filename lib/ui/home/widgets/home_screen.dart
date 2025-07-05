import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/memo/memo.dart';
import '../../../routing/routes.dart';
import '../../../ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            if (widget.viewModel.load.isExecutingSync.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.load.value.isError()) {
              return const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [Icon(Icons.error), Text('An error occurred')],
                ),
              );
            }

            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) => MemosList(viewModel: widget.viewModel),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.viewModel
              .createMemoCommand(name: 'a name', content: 'some content')
              .execute();
        },
        // onPressed: () => context.go(Routes.editor),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemosList extends StatelessWidget {
  const MemosList({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.memos.length,
      itemBuilder: (context, index) =>
          memoSlider(viewModel, viewModel.memos[index]),
    );
  }
}

Slidable memoSlider(HomeViewModel viewModel, Memo memo) {
  return Slidable(
    key: ValueKey(memo),
    endActionPane: ActionPane(
      motion: ScrollMotion(),
      dismissible: Builder(
        builder: (context) => DismissiblePane(
          onDismissed: () => _deleteMemoWithSnackBar(viewModel, memo, context),
        ),
      ),
      children: [
        SlidableAction(
          onPressed: (context) {
            context.go(Routes.editor);
          },
          icon: Icons.edit,
          backgroundColor: Colors.green,
        ),
        SlidableAction(
          onPressed: (context) =>
              _deleteMemoWithSnackBar(viewModel, memo, context),
          icon: Icons.delete,
          backgroundColor: Colors.red,
        ),
      ],
    ),
    child: ListTile(
      title: Row(spacing: 8, children: [Text(memo.name), Text(memo.content)]),
    ),
  );
}

void _deleteMemoWithSnackBar(
  HomeViewModel viewModel,
  Memo memo,
  BuildContext context,
) {
  viewModel.deleteMemo.execute(memo.id);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Memo deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => viewModel
            .createMemoCommand(name: memo.name, content: memo.content)
            .execute(),
      ),
    ),
  );
}
