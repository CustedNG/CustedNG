class NetdiskQuota {
  NetdiskQuota({
    this.quota,
    this.used
  });

  final int quota;
  final int used;

  @override
  String toString() {
    return '$used/$quota';
  }
}