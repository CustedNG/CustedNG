class TTYException implements Exception {
  final String message;

  TTYException(this.message);

  @override
  String toString() {
    return 'TTYException: $message';
  }
}

class TTYInterrupt implements Exception {
  final String message;

  TTYInterrupt(this.message);

  @override
  String toString() {
    return 'TTYInterrupt: $message';
  }
}
