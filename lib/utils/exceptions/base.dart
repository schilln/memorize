class KeyNotFoundException implements Exception {
  KeyNotFoundException([this.message]);

  final String? message;

  @override
  String toString() {
    return 'KeyNotFoundException${message != null ? ': $message' : ''}';
  }
}
