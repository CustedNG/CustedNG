extension ListX<T> on List<T> {
  Map<T, T> toMap() {
    assert(length.isEven);

    final result = <T, T>{};
    for (var i = 0; i < length; i += 2) {
      result[this[i]] = this[i + 1];
    }

    return result;
  }
}
