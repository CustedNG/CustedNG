// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mysso.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _MyssoApi implements MyssoApi {
  _MyssoApi(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getLoginPage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/cas/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  login(data) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/cas/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }
}
