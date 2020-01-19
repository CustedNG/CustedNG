import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:custed2/locator.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' hide Headers;

part 'webvpn.g.dart';

@RestApi(baseUrl: "https://webvpn.cust.edu.cn/")
abstract class WebvpnApi {
  factory WebvpnApi() => _WebvpnApi(_buildDio());

  static Dio _buildDio() {
    return locator<Dio>()..options.followRedirects = false;
  }

  @GET('/')
  Future<String> home();

  // https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1&ticket=ST-72409--byEWTZ9f9W-pwPueQyuyD4IiiUlocalhost
  @GET('/auth/cas_validate')
  Future<String> login(@Query('ticket') String ticket,
      [@Query('entry_id') String entryID = '1']);
}
