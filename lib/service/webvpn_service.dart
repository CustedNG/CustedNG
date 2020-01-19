import 'package:custed2/api/mysso.dart';
import 'package:custed2/api/sys8.dart';
import 'package:custed2/api/webvpn.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

class WebvpnService {
  final _mysso = locator<MyssoService>();
  final _webvpn = locator<WebvpnApi>();

  Future<bool> login() async {
    final ticket = await _mysso.getTicket(
      'https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1',
    );

    print(
      'https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1&ticket=$ticket',
    );

    final resp = await locator<Dio>().get<String>(
      'https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1&ticket=$ticket',
      options: RequestOptions(
        followRedirects: false,
      ),
    );

    return resp.data.contains('user had logged in') || resp.data.contains('success');
  }
}
