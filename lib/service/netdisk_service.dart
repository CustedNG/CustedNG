import 'dart:convert';
import 'dart:io';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/data/models/netdisk_quota.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_based_service.dart';

class NetdiskService extends WebvpnBasedService {
  static const baseUrl = 'http://192-168-223-84-9998-p.webvpn.cust.edu.cn:8118';
  static const authUrl =
      'http://tx-cust-edu-cn.webvpn.cust.edu.cn:8118/ucsso/shiro-cas';

  final MyssoService _mysso = locator<MyssoService>();

  final sessionExpirationTest = RegExp(r'(无效|已过期|不合法|格式错误)');

  var tokenid = '';

  @override
  Future<CatLoginResult<String>> login() async {
    final ticket = await _mysso.getTicketForNetdisk();
    final resp = await xRequest(
      'GET',
      '$authUrl?ticket=$ticket',
      maxRedirects: 0,
    );
    final loginUrl = resp.headers[HttpHeaders.locationHeader];
    final tokenid = RegExp('tokenid=([a-z,0-9,-]+)')?.firstMatch(loginUrl)?.group(1);
    final ok = tokenid != null;
    this.tokenid = tokenid ?? this.tokenid;
    return CatLoginResult(ok: ok, data: loginUrl);
  }

  Future<NetdiskQuota> getQuota() async {
    final resp = await xRequest(
      'POST',
      () => '$baseUrl/v1/quota?method=getuserquota&tokenid=$tokenid',
    );
    final data = json.decode(resp.body);
    return NetdiskQuota(
      quota: data['quotainfos'][0]['quota'],
      used: data['quotainfos'][0]['used'],
    );
  }
}
