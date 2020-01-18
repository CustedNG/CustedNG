import 'package:custed2/locator.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'mysso.g.dart';

@RestApi(baseUrl: "http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/")
abstract class MyssoApi {
  factory MyssoApi() => _MyssoApi(_buildDio());

  static Dio _buildDio() {
    return locator<Dio>();
  }

  @GET("/cas/login")
  Future<String> getLoginPage();
}