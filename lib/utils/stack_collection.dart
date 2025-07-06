class StackCollection<T> {
  final List<T> _items = [];

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  int get length => _items.length;

  void push(final T item) => _items.add(item);
  T pop() => _items.removeLast();

  T get peek => _items.last;

  @override
  String toString() {
    return _items.toString();
  }
}
