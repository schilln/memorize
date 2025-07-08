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
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            spacing: 8,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  viewModel.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListenableBuilder(
                listenable: Listenable.merge([
                  viewModel.fractionWordsKeepListenable,
                  viewModel.keepFirstLettersListenable,
                ]),
                builder: (_, _) {
                  return Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Text(
                          viewModel.content,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SliderRow(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderRow extends StatefulWidget {
  const SliderRow({super.key, required this.viewModel});

  final MemorizeViewModel viewModel;

  @override
  State<SliderRow> createState() => _SliderRowState();
}

class _SliderRowState extends State<SliderRow> {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Switch(
            value: widget.viewModel.keepFirstLetters,
            onChanged: (final bool value) {
              setState(() {
                widget.viewModel.keepFirstLetters = value;
              });
            },
          ),
          Expanded(
            child: Slider(
              value: widget.viewModel.fractionWordsKeep,
              onChanged: (final double value) {
                setState(() {
                  widget.viewModel.fractionWordsKeep = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
