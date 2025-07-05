class CommandNotExecutedException implements Exception {
  CommandNotExecutedException([this.message]);

  final String? message;

  @override
  String toString() {
    return 'CommandNotExecutedException${message != null ? ': $message' : ''}';
  }
}
