import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../view_models/editor_viewmodel.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.viewModel});

  final EditorViewmodel viewModel;

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
          child: ItemForm(viewModel: viewModel),
        ),
      ),
    );
  }
}

class ItemForm extends StatelessWidget {
  ItemForm({super.key, required final viewModel})
    : _viewModel = viewModel,
      _nameController = viewModel.nameController,
      _contentController = viewModel.contentController;

  final EditorViewmodel _viewModel;

  final TextEditingController _nameController;
  final TextEditingController _contentController;

  @override
  Widget build(final BuildContext context) {
    return Form(
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            onSaved: (final value) {},
          ),
          ContentTextBox(_contentController),
          ButtonRow(viewModel: _viewModel),
        ],
      ),
    );
  }
}

class ContentTextBox extends StatelessWidget {
  final TextEditingController _controller;

  const ContentTextBox(this._controller, {super.key});

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
        onSaved: (final value) {},
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key, required this.viewModel});

  final EditorViewmodel viewModel;

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

            // FormState form = Form.of(context);
            // form.validate();
            // form.save();
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
