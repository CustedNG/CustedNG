import 'package:custed2/api/mysso.dart';
import 'package:custed2/api/sys8.dart';
import 'package:custed2/api/webvpn.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

class Sys8Service {
  final _api = locator<Sys8Api>();
  final _mysso = locator<MyssoService>();
  final _webvpn = locator<WebvpnService>();

  Future<bool> login() async {
    final ticket = await _mysso.getTicket('http://192.168.223.72:8080/welcome');
    if (ticket == null) {
      return false;
    }

    await _webvpn.login();

    print(Sys8Params({
      'Ticket': ticket,
      'Url': 'http://192.168.223.72:8080/welcome',
    }).toJson());

    final resp = await _api.myssoLogin(Sys8Params({
      'Ticket': ticket,
      'Url': 'http://192.168.223.72:8080/welcome',
    }));

    

    print(resp);
    return false;
  }

  Future<String> getSchedule() async {
    final loginSuccess = await login();
    if (!loginSuccess) {
      return null;
    }

    try {
      final schedule = await _api.getSchedule();
      return schedule;
    } on DioError catch (e) {
      print(e.response.headers);
    }

    return null;
  }
}
