import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:custed2/data/models/jw_response.dart';
import 'package:custed2/locator.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' hide Headers;

part 'sys8.g.dart';

@RestApi(baseUrl: "http://192-168-223-72-8080-p.webvpn.cust.edu.cn:8118/")
abstract class Sys8Api {
  factory Sys8Api() => _Sys8Api(_buildDio());

  static Dio _buildDio() {
    return locator<Dio>()
      ..options.followRedirects = true
      ..options.maxRedirects = 10;
  }

  @GET('/')
  Future<String> home();

  @POST('/api/LoginApi/LGSSOLocalLogin')
  Future<String> myssoLogin(@Body() Sys8Params params);

  @POST("/api/ClientStudent/Home/StudentHomeApi/QueryStudentScheduleData")
  Future<JwResponse> getSchedule([
    @Body() Sys8Params params = const Sys8Params({}),
  ]);
}

class Sys8Params {
  const Sys8Params(this.params);

  final Map<String, dynamic> params;

  Map<String, dynamic> toJson() {
    return {
      'param': encodeParams(params),
    };
  }

  static encodeParams(Map<String, dynamic> params) {
    var encoded = percent.encode(utf8.encode(
      json.encode(params),
    ));

    const replaceList = [
      '%23',
      '%24',
      '%26',
      '%2C',
      '%2B',
      '%3A',
      '%40',
      '%5B',
      '%5D',
      '%5E',
      '%60',
      '%7C'
    ];

    for (var char in replaceList) {
      final replaceChar = utf8.decode(percent.decode(char));
      encoded.replaceAll(char, replaceChar);
    }

    return base64.encode(utf8.encode(encoded));
  }
}
