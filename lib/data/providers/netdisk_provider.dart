import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/data/models/netdisk_quota.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/netdisk_service.dart';

class NetdiskProvider extends BusyProvider {
  NetdiskQuota _quota;
  NetdiskQuota get quota => _quota;

  Future<void> getQuota() async {
    busyRun(_getquota);
  }

  Future<void> _getquota() async {
    final quota = await locator<NetdiskService>().getQuota();
    _quota = quota;
  }
}
