import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_based_service.dart';

class PortalService extends WebvpnBasedService {
  final MyssoService _mysso = locator<MyssoService>();

  @override
  Future<CatLoginResult> login() async {
    final resp = await _mysso.xRequest(
      'GET',
      Uri.parse(
          'http://portal-cust-edu-cn-s.webvpn.cust.edu.cn:8118/custp/index'),
    );
    return CatLoginResult(ok: resp.body.contains('修改密码'));
  }
}
