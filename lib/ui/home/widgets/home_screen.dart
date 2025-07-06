import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/memo/memo.dart';
import '../../../routing/routes.dart';
import '../../../ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel.load,
          builder: (context, child) {
            if (viewModel.load.isExecutingSync.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.load.value.isError()) {
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
            listenable: viewModel,
            builder: (context, child) => MemosList(viewModel: viewModel),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          context.go(Routes.editor);
        },
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
          MemoSlider(viewModel: viewModel, memo: viewModel.memos[index]),
    );
  }
}

class MemoSlider extends StatelessWidget {
  const MemoSlider({super.key, required viewModel, required memo})
    : _viewModel = viewModel,
      _memo = memo;

  final HomeViewModel _viewModel;
  final Memo _memo;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(_memo),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: Builder(
          builder: (context) => DismissiblePane(
            onDismissed: () =>
                _deleteMemoWithSnackBar(_viewModel, _memo, context),
          ),
        ),
        children: [
          SlidableAction(
            onPressed: (context) {
              ScaffoldMessenger.of(context).clearSnackBars();
              context.go(Routes.editor);
            },
            icon: Icons.edit,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: (context) =>
                _deleteMemoWithSnackBar(_viewModel, _memo, context),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        title: Row(
          spacing: 8,
          children: [Text(_memo.name), Text(_memo.content)],
        ),
      ),
    );
  }
}

void _deleteMemoWithSnackBar(
  HomeViewModel viewModel,
  Memo memo,
  BuildContext context,
) {
  viewModel.deleteMemo(id: memo.id);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Memo deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => viewModel.undoDelete(),
      ),
    ),
  );
}
