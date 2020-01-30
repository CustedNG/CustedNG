extension DurationX on Duration {
  Future<void> sleep() {
    return Future.delayed(this);
  }
}