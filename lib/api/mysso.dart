import 'package:custed2/locator.dart';
import 'package:dio/dio.dart';

class MyssoApi {
  final Dio _dio = _buildDio();

  static Dio _buildDio() {
    return locator<Dio>()
      ..options.baseUrl = 'http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/'
      ..options.contentType = Headers.formUrlEncodedContentType;
  }

  Future<String> getLoginPage() async {
    final resp = await _dio.request<String>(
      '/cas/login',
      options: RequestOptions(method: 'GET'),
    );
    return resp.data;
  }

  Future<String> login(MyssoLoginData data) async {
    final resp = await _dio.request<String>('/cas/login',
        options: RequestOptions(
          method: 'POST',
          data: data.toJson(),
        ));
    return resp.data;
  }

  Future<String> getTicket(String service) async {
    // Example
    // http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/cas/login?service=http://192.168.223.72:8080/welcome

    final resp = await _dio.get(
      '/cas/login',
      queryParameters: {
        'service': service,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status == 302,
      ),
    );

    final redirect = Uri.parse(resp.headers.value('location'));
    return redirect.queryParameters['ticket'];
  }

  Future<void> auth(String service) async {
    // Example
    // http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/cas/login?service=http://192.168.223.72:8080/welcome

    final resp = await _dio.get(
      '/cas/login',
      queryParameters: {
        'service': service,
      },
      options: Options(
        followRedirects: true,
      ),
    );
  }
}

class MyssoLoginData {
  MyssoLoginData({
    this.username,
    this.password,
    this.execution,
  });

  String username;
  String password;
  String execution;

  Map<String, String> toJson() => {
        'username': username,
        'password': password,
        'execution': execution,
        '_eventId': 'submit',
        'geolocation': '',
      };
}
