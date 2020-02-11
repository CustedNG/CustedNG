class TTYException implements Exception {
  final String message;

  TTYException(this.message);

  @override
  String toString() {
    return 'TTYException: $message';
  }
}
