import 'package:flutter/material.dart';
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
            builder: (context, child) =>
                MemosList(memos: widget.viewModel.memos),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(Routes.editor),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemosList extends StatelessWidget {
  const MemosList({super.key, required this.memos});

  final List<Memo> memos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: memos.length,
      itemBuilder: (context, index) {
        final memo = memos[index];
        return Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            spacing: 8,
            children: [Text(memo.name), Text(memo.content)],
          ),
        );
      },
    );
  }
}
