import 'package:flutter/material.dart';

import '../view_models/editor_viewmodel.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.viewModel});

  final EditorViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Memo editor'),
      ),
      body: Text('editor screen here'),
    );
  }
}
