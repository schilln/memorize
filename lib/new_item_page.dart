import 'package:flutter/material.dart';

class NewItemPage extends StatelessWidget {
  const NewItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("New item"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 32),
        child: Column(
          spacing: 8,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Name"),
              onSubmitted: (value) {},
            ),
            ContentTextBox(),
            ButtonRow(),
          ],
        ),
      ),
    );
  }
}

class ContentTextBox extends StatelessWidget {
  const ContentTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          labelText: "Content",
          alignLabelWithHint: true,
        ),
        onSubmitted: (value) {},
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  static const _padding = 8;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Row(
            spacing: _padding.toDouble(),
            children: [Icon(Icons.delete), Text("Discard")],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Row(
            spacing: _padding.toDouble(),
            children: [Icon(Icons.save_alt), Text("Save and exit")],
          ),
        ),
      ],
    );
  }
}
