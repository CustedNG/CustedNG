import 'dart:io';

import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/data/models/mysso_profile.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart' show parse;

class MyssoService extends CatService {
  static const baseUrl = 'https://mysso.cust.edu.cn';
  static const loginUrl = '$baseUrl/cas/login';

  static String parseValue(String value) {
    // just handle string case for now.
    // [xxx] -> xxx
    if (value == null) return null;
    if (value.startsWith('[') && value.endsWith(']')) {
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  final sessionExpirationTest = RegExp(r'(用户登录|登录后可|微信扫码|账号密码)');
  final loginSuccessTest = RegExp(r'(登录成功|成功登录|Log In Successful|进入校园门户)');
  final needCaptchaTest = RegExp(r'验证码');

  Future<CatLoginResult<String>> login({bool force = false}) async {
    if (force) clearCookieFor(baseUrl.toUri());

    final loginService = 'https://portal.cust.edu.cn/custp/shiro-cas';
    final loginUrlWithService = '$loginUrl?service=$loginService';

    // final loginPage = await getFrontPage(loginUrlWithService);
    // if (loginSuccessTest.hasMatch(loginPage)) {
    //   print('Mysso Cookie Login Success');
    //   return CatLoginResult.ok();
    // }

    final loginPage = await get(
      loginUrlWithService,
      maxRedirects: 0,
    );

    if (loginPage.statusCode.isWithin(300, 399) &&
        loginPage.headers['location'].contains(loginService)) {
      print('Mysso Manual Login Success');
      return CatLoginResult.ok();
    }

    final userData = await locator.getAsync<UserDataStore>();

    final loginPageParsed = parse(loginPage.body);
    final execution = loginPageParsed
        .querySelector('input[name=execution]')
        .attributes['value'];

    final resp = await post(
      loginUrlWithService,
      body: {
        'username': userData.username.fetch(),
        'password': userData.password.fetch(),
        'execution': execution,
        '_eventId': 'submit',
        'geolocation': '',
      },
      maxRedirects: 0,
    );

    if (needCaptchaTest.hasMatch(resp.body)) {
      final controller = TextEditingController();
      final ctx = locator<AppProvider>().ctx;
      await showRoundDialog(
        ctx, 
        '请输入验证码', 
        TextField(
          controller: controller,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            icon: Icon(Icons.security),
            labelText: '验证码',
          ),
        ), 
        [
          TextButton(
            onPressed: () {
              showRoundDialog(
                ctx, 
                '关于验证码', 
                Text('近期由于学校提升了账户安全等级，登录教务需要验证码\n验证码需要在企业微信获取，具体步骤可以在信息化中心获取，或者加入用户群：1057534645询问热心好群友'), 
                [TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), 
                  child: Text('确定')
                )]
              );
            }, 
            child: Text('验证码？', style: TextStyle(color: Colors.red),)
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), 
            child: Text('确定')
          ),
          
        ]
      );
      final captchaPageParsed = parse(resp.body);
      final captchaResp = await post(
        loginUrlWithService,
        body: {
          'vc': controller.text,
          'execution': captchaPageParsed.querySelector('input[name=execution]')
                                      .attributes['value'],
          '_eventId': 'submit',
          'submit': '%E6%8F%90%E4%BA%A4'
        }
      );

      if (captchaResp.statusCode.isWithin(300, 399)) {
        print('Mysso Manual Login Success');
        return CatLoginResult.ok();
      }
      return CatLoginResult.failed('验证失败');
    }
    

    final reason =
        parse(resp.body).querySelector('.alert-danger')?.text?.trim() ?? '未知原因';
    print('Mysso Manual Login Failed：$reason');
    return CatLoginResult.failed(reason);
  }

  Future<MyssoProfile> getProfile() async {
    final document = parse((await xRequest('GET', loginUrl.toUri())).body);
    final custId = document.querySelector('strong > span')?.innerHtml ??
        document.querySelector('p > strong')?.innerHtml ??
        '用户';

    final data = Map.fromIterables(
      document.querySelectorAll('td > kbd > span').map((e) => e.innerHtml),
      document.querySelectorAll('td > code > span').map((e) => e.innerHtml),
    );
    return MyssoProfile(
      custId: custId,
      name: parseValue(data['CN']),
      surname: parseValue(data['SN']),
      cookie: parseValue(data['cookie']),
      memberOf: parseValue(data['MEMBEROF']),
      pass: parseValue(data['PASS']),
      college: parseValue(data['college']),
      grade: int.tryParse(parseValue(data['grade'])),
      sno: parseValue(data['sno']),
    );
  }

  Future<String> getFrontPage([String url = loginUrl]) async {
    final resp = await this.get(url);
    return resp.body;
  }

  Future<String> getTicket(String service) async {
    final response = await xRequest(
      'GET',
      Uri.parse('$baseUrl/cas/login?service=$service'),
      maxRedirects: 0,
    );

    if (response.isRedirect) {
      final location = response.headers[HttpHeaders.locationHeader];
      return Uri.parse(location).queryParameters['ticket'];
    }

    return null;
  }

  Future<String> getTicketForPortal() =>
      getTicket('https://portal.cust.edu.cn/custp/shiro-cas');

  Future<String> getTicketForWebvpn() =>
      getTicket('https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1');

  Future<String> getTicketForWrdvpn() =>
      getTicket('http://wwwn.cust.edu.cn/wengine-auth/login?cas_login=true');

  Future<String> getTicketForJw() =>
      getTicket(locator<JwService>().baseUrl + '/welcome');

  Future<String> getTicketForIecard() =>
      getTicket('http://iecard.cust.edu.cn:8080/ias/prelogin?sysid=FWDT');

  Future<String> getTicketForNetdisk() =>
      getTicket('http://tx.cust.edu.cn/ucsso/shiro-cas');
}
