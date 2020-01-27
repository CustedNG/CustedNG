extension IterableX<T> on Iterable<T> {
  T get firstIfExist {
    if (this ==  null || this.isEmpty) return null;
    return this.first;
  }
}
