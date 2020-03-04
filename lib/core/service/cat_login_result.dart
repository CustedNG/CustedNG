class CatLoginResult<T> {
  CatLoginResult({this.ok, this.data});

  CatLoginResult.ok([this.data]) : ok = true;

  CatLoginResult.failed([this.data]) : ok = false;

  final bool ok;
  final T data;

  @override
  String toString() {
    final status = ok ? 'ok' : 'failed';
    final extra = data != null ? ',$data' : '';
    return '$status$extra';
  }
}
