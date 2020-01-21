import 'package:http/http.dart';

class CasService extends BaseClient {
  final Client _client = Client();

  Future<StreamedResponse> send(BaseRequest request) {
    print('request: ${request.url}');
    return _client.send(request);
  }

  void test() async {
    final resp = await this.get('http://portal-cust-edu-cn.webvpn.cust.edu.cn:8118/');
    print(resp.isRedirect);
    print(resp.headers);
    print(resp.body);
    // CasRequest(
    //     'GET', Uri.parse('http://portal-cust-edu-cn.webvpn.cust.edu.cn:8118/'))
    //   ..followRedirects = true;
  }
}

class CasRequest extends BaseRequest {
  CasRequest(String method, Uri url) : super(method, url);
}
