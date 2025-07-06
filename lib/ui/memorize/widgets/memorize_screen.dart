import 'package:flutter/material.dart';

import '../view_models/memorize_viewmodel.dart';

class MemorizeScreen extends StatelessWidget {
  const MemorizeScreen({super.key, required this.viewModel});

  final MemorizeViewModel viewModel;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memorize')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(viewModel.memo.name), Text(viewModel.memo.content)],
          ),
        ),
      ),
    );
  }
}
