import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';

class WebvpnService extends CatService {
  static const baseUrl = 'https://webvpn.cust.edu.cn';
  static const baseUrlInsecure = 'http://webvpn.cust.edu.cn';

  final Pattern sessionExpirationTest = RegExp(r'g_lines|Sangine');

  final MyssoService _mysso = locator<MyssoService>();

  Future<CatLoginResult> login() async {
    final ticket = await _mysso.getTicketForWebvpn();

    final resp = await get(
      '$baseUrl/auth/cas_validate?entry_id=1&ticket=$ticket',
      maxRedirects: 0,
    );

    return CatLoginResult(
      ok: resp.body.contains(RegExp(r'(success|logged in)')),
    );
  }
}
