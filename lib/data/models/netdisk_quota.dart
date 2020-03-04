class NetdiskQuota {
  NetdiskQuota({
    this.type,
    this.quota,
    this.used
  });

  final String type;
  final int quota;
  final int used;

  @override
  String toString() {
    return '$type[$used/$quota]';
  }
}