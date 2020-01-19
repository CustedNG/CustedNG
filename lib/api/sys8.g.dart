// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sys8.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _Sys8Api implements Sys8Api {
  _Sys8Api(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://192-168-223-72-8080-p.webvpn.cust.edu.cn:8118/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  home() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/',
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
  myssoLogin(params) async {
    ArgumentError.checkNotNull(params, 'params');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(params.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request(
        '/api/LoginApi/LGSSOLocalLogin',
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

  @override
  getSchedule([params = const Sys8Params({})]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(params.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request(
        '/api/ClientStudent/Home/StudentHomeApi/QueryStudentScheduleData',
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
