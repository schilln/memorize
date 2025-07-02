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
      body: Text("hi"),
    );
  }
}
