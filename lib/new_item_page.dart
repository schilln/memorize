import 'package:flutter/material.dart';
import 'package:memorize/item.dart';

class NewItemPage extends StatelessWidget {
  final Item _item;

  const NewItemPage(this._item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("New item"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 32),
        child: ItemForm(),
      ),
    );
  }
}

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            onSaved: (value) {},
          ),
          ContentTextBox(),
          ButtonRow(),
        ],
      ),
    );
  }
}

class ContentTextBox extends StatelessWidget {
  const ContentTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          labelText: "Content",
          alignLabelWithHint: true,
        ),
        onSaved: (value) {},
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
          onPressed: () => Navigator.pop(context),
          child: Row(
            spacing: _padding.toDouble(),
            children: [Icon(Icons.delete), Text("Discard changes")],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            FormState form = Form.of(context);
            form.validate();
            form.save();
          },
          child: Row(
            spacing: _padding.toDouble(),
            children: [Icon(Icons.save_alt), Text("Save and exit")],
          ),
        ),
      ],
    );
  }
}
