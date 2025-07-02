import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  final List<Text> _items = [];

  void _addItem() {
    setState(() {
      _items.add(Text(_counter.toString()));
      _counter++;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Items"),
      ),
      body: Center(
        // child: Text(_counter.toString()),
        child: _items.isEmpty
            ? Text("No items yet")
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _items.length,
                itemBuilder: (context, index) => buildItem(index),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Dismissible buildItem(int index) {
    return Dismissible(
      key: ValueKey(_items[index]),
      onDismissed: (direction) => _removeItem(index),
      child: ListTile(title: _items[index]),
    );
  }
}
