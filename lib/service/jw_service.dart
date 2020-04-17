import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_response.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/jw_student_info.dart';
import 'package:custed2/data/models/jw_week_time.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_based_service.dart';

class JwService extends WebvpnBasedService {
  static const baseUrl = 'http://192-168-223-72-8080-p.webvpn.cust.edu.cn:8118';
  
  final MyssoService _mysso = locator<MyssoService>();

  @override
  final Pattern sessionExpirationTest = '过期';

  @override
  Future<CatLoginResult<String>> login() async {
    final ticket = await _mysso.getTicketForJw();
    final response = await request(
      'POST',
      '$baseUrl/api/LoginApi/LGSSOLocalLogin'.toUri(),
      body: encodeParams({
        'Ticket': ticket,
        'Url': 'http://192.168.223.72:8080/welcome',
      }),
      headers: {
        'content-type': 'application/json',
      },
    );

    final parsedResponse = JwResponse.fromJson(json.decode(response.body));
    return CatLoginResult(ok: parsedResponse.isSuccess, data: ticket);
  }

  Future<JwSchedule> getSchedule() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentHomeApi/QueryStudentScheduleData'
          .toUri(),
      body: encodeParams({}),
      headers: {'content-type': 'application/json'},
    );

    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwSchedule.fromJson(parsedResponse.data);
  }

  Future<JwGradeData> getGrade() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/QueryService/GradeQueryApi/GetDataByStudent'
          .toUri(),
      body: {
        // {"ShowGradeType":1} -> url -> base64
        'param': 'JTdCJTIyU2hvd0dyYWRlVHlwZSUyMjoxJTdE',
        '__log': {
          'MenuID': '4443798E-EB6E-4D88-BFBD-BB0A76FF6BD5',
          'Logtype': 6,
          'Context': '查询',
        },
        '__permission': {
          'MenuID': '4443798E-EB6E-4D88-BFBD-BB0A76FF6BD5',
          'Operation': 0
        },
      },
      headers: {'content-type': 'application/json'},
    );

    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwGradeData.fromJson(parsedResponse.data);
  }

  Future<JwStudentInfo> getStudentInfo() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentInfoApi/GetSudentInfoByStudentId'
          .toUri(),
      body: encodeParams({}),
      headers: {'content-type': 'application/json'},
    );

    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwStudentInfo.fromJson(parsedResponse.data);
  }

  Future<JwWeekTime> getWeekTime() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentHomeApi/GetHomeCurWeekTime'
          .toUri(),
      body: encodeParams({}),
      headers: {'content-type': 'application/json'},
    );

    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwWeekTime.fromJson(parsedResponse.data);
  }

  // Future<

  static Map<String, dynamic> encodeParams(Map<String, dynamic> data) {
    var encoded = percent.encode(utf8.encode(
      json.encode(data),
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

    encoded = base64.encode(utf8.encode(encoded));

    return {'param': encoded};
  }
}
