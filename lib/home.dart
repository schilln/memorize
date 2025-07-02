import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memorize/new_item_page.dart';

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

  Slidable buildItem(int index) {
    return Slidable(
      key: ValueKey(_items[index]),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () => _removeItem(index)),
        children: [
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewItemPage()),
              );
            },
            icon: Icons.edit,
            backgroundColor: Colors.green,
          ),
          /* TODO: An undo button would be good. Maybe a pop-up requesting
          confirmation but that would probably be annoying. */
          SlidableAction(
            onPressed: (context) => _removeItem(index),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(title: _items[index]),
    );
  }
}
