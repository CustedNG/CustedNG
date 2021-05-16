import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_response.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/jw_student_info.dart';
import 'package:custed2/data/models/jw_week_time.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/remote_config_service.dart';
import 'package:custed2/service/wrdvpn_based_service.dart';
import 'package:http/http.dart';

class JwService extends WrdvpnBasedService {
  String get baseUrl {
    return locator<RemoteConfigService>()
        .fetchSync('jwglBaseUrl', 'https://jwgls2.cust.edu.cn');
  }

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
        'Url': '$baseUrl/welcome',
      }),
      headers: {
        'content-type': 'application/json',
      },
    );

    final parsedResponse = JwResponse.fromJson(json.decode(response.body));
    return CatLoginResult(ok: parsedResponse.isSuccess, data: ticket);
  }

  Future<JwSchedule> getSchedule([String userUUID]) async {
    await locator<RemoteConfigService>().reloadData();

    // {"KBLX":"2","CXLX":"0","XNXQ":"20202","CXID":"b0a3fc3c-8263-4be8-bb53-58fe200f616e","CXZC":"3","JXBLX":"","IsOnLine":"-1"}
    final resp =
        await (userUUID == null ? getSelfSchedule() : getScheduleByUUID(userUUID));
    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwSchedule.fromJson(parsedResponse.data);
  }

  Future<Response> getSelfSchedule() async {
    final requestUrl =
        '$baseUrl/api/ClientStudent/Home/StudentHomeApi/QueryStudentScheduleData';

    final resp = await xRequest(
      'POST',
      requestUrl.toUri(),
      body: encodeParams({}),
      headers: {'content-type': 'application/json'},
    );

    final ecardId = locator<UserDataStore>().username.fetch();

    if (resp.statusCode == 200) {
      final result4SendChedule = 
          await CustedService().updateScheduleCache2Backend(ecardId, resp.body);
      print('send cache schedule to backend: $result4SendChedule');
    } else {
      final cache = await CustedService().getCacheScheduleFromBackend(ecardId);
      print('use cached schedule from backend: ${cache.statusCode}');
      if (cache.statusCode == 200) return cache;
    }

    return resp;
  }

  Future<Response> getScheduleByUUID(String userUUID) async {
    final Map<String, dynamic> params = {
      "KBLX": "2",
      "CXLX": "0",
      "XNXQ": "20202", // seemingly hardcoded?
      "CXID": userUUID,
      "CXZC": "3",
      "JXBLX": "", "IsOnLine": "-1"
    };

    final requestUrl =
        '$baseUrl/api/ClientStudent/QueryService/OccupyQueryApi/QueryScheduleData';

    final resp = await xRequest(
      'POST',
      requestUrl.toUri(),
      body: {
        'param': encodeParamValue(params),
        "__permission": {"MenuID": '1616251313480', "Operation": '0'},
        "__log": {"MenuID": '1616251313480', "Logtype": '6', "Context": "查询"}
      },
      headers: {'content-type': 'application/json'},
    );
    return resp;
  }

  Future<List<CustomScheduleProfile>> getProfileByStudentNumber(
      String studentNumber) async {
    await locator<RemoteConfigService>().reloadData();

    final params = {"TakeNum": 30, "SearchText": studentNumber};
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/CommonApi/GetStudentDropDownDataBySearchText'.toUri(),
      body: {
        "param": encodeParamValue(params),
        "__permission": {"MenuID": "1616251313480", "Operation": "0"},
        "__log": {"MenuID": "1616251313480", "Logtype": "6", "Context": "查询"}
      },
      headers: {'content-type': 'application/json'},
    );

    var responseBody = resp.body;
    Map<String, dynamic> response = json.decode(responseBody);
    final dataList = response['data'];
    if (dataList == null || !(dataList is List)) {
      print(
          "Getting profile for $studentNumber: data list is null or not a list.");
      return null;
    }
    if ((dataList as List).isNotEmpty) {
      final ret = <CustomScheduleProfile>[];
      for (final dataItem in dataList) {
        final text = dataItem['TEXT'] as String;
        final idx = text.indexOf('[');
        final name = text.substring(0, idx);
        final number = text.substring(idx + 1, text.length - 1);
        final uuid = (dataItem['VALUE'] as String).trim();
        ret.add(CustomScheduleProfile(
            name: name, studentNumber: number, uuid: uuid));
      }
      print("Profiles for $studentNumber: $ret");
      return ret;
    }
    print("Profiles for $studentNumber is empty");
    return [];
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

  Future<String> getStudentPhoto() async {
    final ticket = await _mysso.getTicketForJw();
    final response = await request(
      'POST',
      '$baseUrl/api/LoginApi/LGSSOLocalLogin'.toUri(),
      body: encodeParams({
        'Ticket': ticket,
        'Url': '$baseUrl/welcome',
      }),
      headers: {
        'content-type': 'application/json',
      },
    );

    final parsedResponse = JwResponse.fromJson(json.decode(response.body));
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/CommonApi/GetFileContentById'.toUri(),
      body: {
        'param': base64Encode(utf8.encode('%7B%22Id%22%3A%22'
            '${parsedResponse.data['StudentDto']['ZPID']}%22%7D')),
        '__log': {
          'Context': '查询',
          'Logtype': 6,
          'MenuID': '4443798E-EB6E-4D88-BFBD-BB0A76FF6BD5'
        },
        '__permission': {
          'MenuID': '4443798E-EB6E-4D88-BFBD-BB0A76FF6BD5',
          'Operation': 0
        }
      },
      headers: {'content-type': 'application/json'},
    );

    Map<String, dynamic> jsonData = json.decode(resp.body);
    return jsonData['data']['ZZCLBlob']['Base64String'];
  }

  Future<JwExam> getExam() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentHomeApi/QueryStudentExamAssign',
      body: {
        'param': 'JTdCJTdE',
        '__permission': {
          'MenuID': '00000000-0000-0000-0000-000000000000',
          "Operation": 0
        },
        "__log": {
          "MenuID": "00000000-0000-0000-0000-000000000000",
          "Logtype": 6,
          "Context": "查询"
        }
      },
      headers: {'content-type': 'application/json'},
    );

    return JwExam.fromJson(json.decode(resp.body));
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
    return {'param': encodeParamValue(data)};
  }

  static String encodeParamValue(Map<String, dynamic> data) {
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
    return encoded;
  }
}
