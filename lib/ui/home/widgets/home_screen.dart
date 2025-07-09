import 'dart:developer';

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
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: viewModel.load,
            builder: (final context, final child) {
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

              return MemosList(viewModel: viewModel);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          context.push(Routes.editor);
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
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
      child: ListView.builder(
        itemCount: viewModel.memos.length,
        itemBuilder: (final context, final index) =>
            MemoSlider(viewModel: viewModel, index: index),
      ),
    );
  }
}

class MemoSlider extends StatelessWidget {
  MemoSlider({super.key, required final viewModel, required final index})
    : _viewModel = viewModel,
      _memo = viewModel.memos[index],
      _index = index;

  final HomeViewModel _viewModel;
  final Memo _memo;
  final int _index;

  @override
  Widget build(final BuildContext context) {
    return Slidable(
      key: ValueKey(_memo),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: Builder(
          builder: (final context) => DismissiblePane(
            onDismissed: () =>
                _deleteMemoWithSnackBar(_viewModel, _memo, context),
          ),
        ),
        children: [
          SlidableAction(
            onPressed: (final context) {
              ScaffoldMessenger.of(context).clearSnackBars();
              context.push('${Routes.editor}/${_memo.id}');
            },
            icon: Icons.edit,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: (final context) =>
                _deleteMemoWithSnackBar(_viewModel, _memo, context),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          context.push(Routes.memorize(_memo.id));
        },
        child: Card(
          color: _index.isOdd
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryFixedDim,
          elevation: 1,
          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(2),
          ),
          child: ListTile(
            title: LayoutBuilder(
              builder: (final context, final constraints) => Row(
                spacing: 16,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * 0.8,
                    ),
                    child: Text(
                      _memo.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _memo.content.replaceAll('\n', ' \u2022 '),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _deleteMemoWithSnackBar(
  final HomeViewModel viewModel,
  final Memo memo,
  final BuildContext context,
) {
  viewModel.deleteMemoCommand.execute(memo.id);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Memo deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          try {
            if (!viewModel.deleteMemoCommand.isExecuting.value) {
              viewModel.deleteMemoCommand.undo();
            }
          } on AssertionError catch (e) {
            if (e.toString().contains('_undoStack.isNotEmpty')) {
              // TODO: Set up a logger.
              log('`undo` tried to pop an empty stack', error: e);
            } else {
              rethrow;
            }
          }
        },
      ),
    ),
  );
}
