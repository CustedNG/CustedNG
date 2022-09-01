import 'dart:convert';
import 'dart:math';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:encrypt/encrypt.dart';

import 'package:convert/convert.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/models/jw_empty_room.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_response.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/jw_student_info.dart';
import 'package:custed2/data/models/jw_week_time.dart';
import 'package:custed2/data/models/kbpro_schedule.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/wrdvpn_based_service.dart';
import 'package:http/http.dart';

class JwService extends WrdvpnBasedService {
  // String _baseUrl;
  String get baseUrl {
    /// 每次都重新获取，以免内存内的失效
    // if (_baseUrl != null) return _baseUrl;
    final user = locator<UserDataStore>();
    return user.lastLoginServer.fetch() ??
        'https://jwgls${Random().nextInt(4)}.cust.edu.cn';
  }

  final MyssoService _mysso = locator<MyssoService>();
  final custed = CustedService();

  @override
  final Pattern sessionExpirationTest = '过期';

  @override
  Future<CatLoginResult<JwResponse>> login() async {
    final ticket = await _mysso.getTicketForJw();
    final param = encodeParams({
      'Ticket': ticket,
      'Url': 'https://jwgl.cust.edu.cn/welcome',
    });
    param.addAll({"__permission": {}, "__log": {}});
    final response = await request(
      'POST',
      '$baseUrl/api/LoginApi/LGSSOLocalLogin'.uri,
      body: param,
      headers: {
        'content-type': 'application/json',
      },
    );

    final parsedResponse = JwResponse.fromJson(json.decode(response.body));
    return CatLoginResult(ok: parsedResponse.isSuccess, data: parsedResponse);
  }

  Future<JwSchedule> getSchedule([String userUUID]) async {
    if (!locator<AppProvider>().showRealUI) {
      print('using fake schedule');
      return await custed.getCacheSchedule();
    }

    // {"KBLX":"2","CXLX":"0","XNXQ":"20202","CXID":"b0a3fc3c-8263-4be8-bb53-58fe200f616e","CXZC":"3","JXBLX":"","IsOnLine":"-1"}
    if (userUUID == null) {
      return getSelfSchedule();
    }
    final resp = await getScheduleByUUID(userUUID);
    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwSchedule.fromJson(parsedResponse.data);
  }

  Future<JwSchedule> getSelfSchedule() async {
    final requestUrl =
        '$baseUrl/api/ClientStudent/Home/StudentHomeApi/QueryStudentScheduleData';

    final resp = await xRequest(
      'POST',
      requestUrl.uri,
      body: {
        "param": "JTdCJTdE",
        "__permission": {
          "MenuID": "00000000-0000-0000-0000-000000000000",
          "Operate": "select",
          "Operation": 0
        },
        "__log": {
          "MenuID": "00000000-0000-0000-0000-000000000000",
          "Logtype": 6,
          "Context": "查询"
        }
      },
      expireTest: (resp) => resp.statusCode != 200,
      headers: {'content-type': 'application/json'},
    );

    if (resp.statusCode == 200 && resp.body.length > 50) {
      final result4SendSchedule = await custed.updateCachedSchedule(resp.body);
      print('send cache schedule to backend: $result4SendSchedule');
      final jwResp = JwResponse.fromJson(json.decode(resp.body));
      return JwSchedule.fromJson(jwResp.data);
    } else {
      final cache = await custed.getCacheSchedule();
      print('use cached schedule from backend');
      return cache;
    }
  }

  Future<List<KBProSchedule>> getSelfScheduleFromKBPro() async {
    if (!locator<AppProvider>().showRealUI) {
      print('using fake schedule kbpro');
      return await custed.getCacheScheduleKBPro();
    }

    final resp = await xRequest(
      'GET',
      'https://kbpro.cust.edu.cn/Schedule/Buser',
      headers: {'content-type': 'application/json;charset=utf-8'},
      expireTest: (res) => res.body.length < 10,
    );

    final key = Key.fromUtf8('ytdxcmqwbQS=@phr');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final result = encrypter.decrypt(Encrypted.fromBase64(resp.body), iv: iv);

    if (resp.statusCode == 200 && resp.body.length > 50) {
      await custed.updateCachedScheduleKBPro(result);
    } else {
      final cache = await custed.getCacheScheduleKBPro();
      print('use cached schedule from backend');
      if (cache != null) return cache;
    }

    final data = json.decode(result);
    final List<KBProSchedule> list = [];
    for (var item in data) {
      list.add(KBProSchedule.fromJson(item));
    }
    return list;
  }

  Future<Response> getScheduleByUUID(String userUUID) async {
    final nowTime = DateTime.now();
    bool lastHalf = nowTime.month < 7;

    final Map<String, dynamic> params = {
      "KBLX": "2",
      "CXLX": "0",
      "XNXQ": (nowTime.year - (lastHalf ? 1 : 0)).toString() +
          (lastHalf ? '2' : '1'),
      "CXID": userUUID,
      "CXZC": "",
      "JXBLX": "",
      "IsOnLine": "-1"
    };

    final requestUrl =
        '$baseUrl/api/ClientStudent/QueryService/OccupyQueryApi/QueryScheduleData';

    final resp = await xRequest(
      'POST',
      requestUrl.uri,
      body: {
        'param': encodeParamValue(params),
        "__permission": {
          "MenuID": '9B419D97-3440-422C-8230-A83292B62FA4',
          "Operate": "select",
          "Operation": '0'
        },
        "__log": {
          "MenuID": '9B419D97-3440-422C-8230-A83292B62FA4',
          "Logtype": '6',
          "Context": "查询"
        }
      },
      headers: {'content-type': 'application/json'},
    );
    return resp;
  }

  Future<List<CustomScheduleProfile>> getProfileByStudentNumber(
      String studentNumber) async {
    final params = {"TakeNum": 30, "SearchText": studentNumber};
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/CommonApi/GetStudentDropDownDataBySearchText'.uri,
      body: {
        "param": encodeParamValue(params),
        "__permission": {
          "MenuID": "9B419D97-3440-422C-8230-A83292B62FA4",
          "Operate": "select",
          "Operation": "0"
        },
        "__log": {
          "MenuID": "9B419D97-3440-422C-8230-A83292B62FA4",
          "Logtype": "6",
          "Context": "查询"
        }
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
    if (!locator<AppProvider>().showRealUI) {
      print('using fake grade.');
      return (await custed.getCachedGrade());
    }

    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/QueryService/GradeQueryApi/GetDataByStudent'
          .uri,
      body: {
        "param": "JTdCJTIyU2hvd0dyYWRlVHlwZSUyMiUzQTAlN0Q=",
        "__permission": {
          "MenuID": "4443798E-EB6E-4D88-BFBD-BB0A76FF6BD5",
          "Operate": "select",
          "Operation": 0
        },
        "__log": {
          "MenuID": "4443798E-EB6E-4D88-BFBD-BB0A76FF6BD5",
          "Logtype": 6,
          "Context": "查询"
        }
      },
      expireTest: (resp) =>
          RegExp(r'{"state":[1-9],"message":".*","data":null}')
              .hasMatch(resp.body),
      headers: {'content-type': 'application/json'},
    );

    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwGradeData.fromJson(parsedResponse.data);
  }

  Future<JwEmptyRoom> getEmptyRoom(
      String date, List<String> sections, String buildingID) async {
    final resp = await xRequest('POST',
        '$baseUrl/api/ClientTeacher/QueryService/EmptyRoomQueryApi/GetEmptyRoomDataByPage',
        body: {
          'param': encodeParamValue({
            'EmptyRoomParam': {'SJ': date, 'JCs': sections},
            'PagingParam': {
              'isPaging': 1,
              'Offset': 0,
              'Limit': 50,
              'Conditions': {
                'PropertyParams': [
                  {'Field': 'BDJXLXXID', 'Value': buildingID}
                ]
              }
            }
          }),
          '__permission': {
            'MenuID': 'E93957BB-C05C-4D97-90F6-7839E1A77B62',
            'Operation': 0
          },
          '__log': {
            'Logtype': 6,
            'MenuID': 'E93957BB-C05C-4D97-90F6-7839E1A77B62',
            'Context': '查询'
          }
        });
    return JwEmptyRoom.fromJson(json.decode(resp.body));
  }

  Future<JwStudentInfo> getStudentInfo() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentInfoApi/GetSudentInfoByStudentId'
          .uri,
      body: encodeParams({}),
      headers: {'content-type': 'application/json'},
    );

    final parsedResponse = JwResponse.fromJson(json.decode(resp.body));
    return JwStudentInfo.fromJson(parsedResponse.data);
  }

  Future<String> getStudentPhoto() async {
    final loginResult = await login();
    final parsedResponse = loginResult.data;
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentHomeApi/GetFileContentById'.uri,
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
    if (!locator<AppProvider>().showRealUI) {
      print('using fake exam');
      return await custed.getCachedExam();
    }

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

    if (resp.statusCode == 200 && resp.body.length > 50) {
      await custed.updateCahedExam(resp.body);
      return JwExam.fromJson(json.decode(resp.body));
    } else {
      return await custed.getCachedExam();
    }
  }

  Future<JwWeekTime> getWeekTime() async {
    final resp = await xRequest(
      'POST',
      '$baseUrl/api/ClientStudent/Home/StudentHomeApi/GetHomeCurWeekTime'.uri,
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
