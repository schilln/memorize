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
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: "Content",
                  alignLabelWithHint: true,
                ),
                onSubmitted: (value) {},
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    spacing: 8,
                    children: [Icon(Icons.delete), Text("Discard")],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    spacing: 8,
                    children: [Icon(Icons.save), Text("Save")],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
