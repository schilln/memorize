import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../view_models/editor_viewmodel.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.viewModel});

  final EditorViewModel viewModel;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Memo editor'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            spacing: 8,
            children: [
              TextFormField(
                controller: viewModel.nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              Expanded(
                child: TextFormField(
                  controller: viewModel.contentController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              ButtonRow(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentTextBox extends StatelessWidget {
  const ContentTextBox(this._controller, {super.key});

  final TextEditingController _controller;

  @override
  Widget build(final BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          labelText: 'Content',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key, required this.viewModel});

  final EditorViewModel viewModel;

  static const _padding = 8;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            spacing: _padding.toDouble(),
            children: [Icon(Icons.delete), Text('Discard changes')],
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await viewModel.save();
            result.fold((final success) {
              if (context.mounted) context.go(Routes.home);
            }, (final e) {});
          },
          child: Row(
            spacing: _padding.toDouble(),
            children: [Icon(Icons.save_alt), Text('Save and exit')],
          ),
        ),
      ],
    );
  }
}
