class CatError implements Exception {
  final message;

  CatError([this.message]);

  @override
  String toString() {
    return 'Cat Error: $message';
  }
}
