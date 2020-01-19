// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webvpn.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _WebvpnApi implements WebvpnApi {
  _WebvpnApi(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://webvpn.cust.edu.cn/';
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
  login(ticket, [entryID = '1']) async {
    ArgumentError.checkNotNull(ticket, 'ticket');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'ticket': ticket,
      'entry_id': entryID
    };
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/auth/cas_validate',
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
}
