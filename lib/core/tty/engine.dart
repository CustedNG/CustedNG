import 'dart:io';

import 'package:alice/alice.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/lisp/lisp.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_frame.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/tty/exception.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/store/lisp_store.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/netdisk_service.dart';
import 'package:custed2/ui/web/common_web_page.dart';
import 'package:custed2/ui/widgets/lisp_debug_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class TTYEngine {
  TTYEngine();

  final _store = LispStore();
  LispInterp _lisp;
  BuildContext _context;
  bool _inited = false;

  Future<void> init() async {
    if (_inited) {
      return;
    }

    await _store.init();
    _lisp = await lispMakeInterp();
    _lisp.currentDir = Directory(await getAppDocDir.invoke());
    _setupFunctions();
    _inited = true;
  }

  void _setupFunctions() {
    // Reference: https://docs.racket-lang.org/racket-cheat/index.html

    _lisp.def('custed-build', 0, _custedBuild);
    _lisp.def('custed-name', 0, _custedName);

    _lisp.def('custed-min-build', 1, _custedMinBuild);
    _lisp.def('custed-max-build', 1, _custedMaxBuild);

    _lisp.def('custed-set', 2, _custedSet);
    _lisp.def('custed-get', 1, _custedGet);

    _lisp.def('custed-wait', 1, _custedWait);
    _lisp.def('custed-notify', 1, _custedNotify);
    _lisp.def('custed-launch-url', 1, _custedLaunchUrl);
    _lisp.def('custed-legacy', -1, _custedLegacy);
    _lisp.def('custed-webview', 1, _custedWebview);

    _lisp.def('debug', 0, _debug);

    _lisp.def('new-year', 0, _newYear);

    _lisp.def('clear', 0, _clear);
    _lisp.def('c', 0, _clear);

    _lisp.def('alice', 0, _openAlice);
    _lisp.def('i', 0, _openAlice);

    _lisp.def('print', 1, _print);

    _lisp.def('test', 0, _test);
    _lisp.def('t', 0, _test);

    _lisp.def('rmrf', 0, _rmrf);

    _lisp.def('cookie-set', 3, _cookieSet);
    // _lisp.def('cookie-delete', 1, _cookieSet);
    // _lisp.def('cookie-delete-all', 0, _cookieSet);
  }

  Future eval(String source) async {
    return _lisp.evalString(source, null);
  }

  void setContext(BuildContext context) {
    final sym = LispSym('custed-context');
    _lisp.globals[sym] = context;
    _context = context;
  }

  _custedMinBuild(List args) {
    final minBuild = args[0];
    if (BuildData.build < minBuild) {
      throw TTYInterrupt('min build: $minBuild');
    }
  }

  _custedMaxBuild(List args) {
    final minBuild = args[0];
    if (BuildData.build > minBuild) {
      throw TTYInterrupt('max build: $minBuild');
    }
  }

  _custedBuild(List args) {
    return BuildData.build;
  }

  _custedName(List args) {
    return BuildData.name;
  }

  _custedSet(List args) {
    final key = args[0] is int ? args[0] : args[0].toString();
    return _store.box.put(key, args[1]);
  }

  _custedGet(List args) {
    final key = args[0] is int ? args[0] : args[0].toString();
    return _store.box.get(key);
  }

  _custedWait(List args) {
    return Future.delayed(Duration(seconds: args[0]));
  }

  _custedLegacy(List args) {
    final cmd = (args[0] as LispCell).car.toString();
    final executer = locator<TTYExecuter>();
    return executer.executeLegacy(cmd, _context);
  }

  _custedNotify(List args) {
    final notification = args[0]?.toString();
    final settings = locator<SettingStore>();
    settings.notification.put(notification);
    return notification;
  }

  _custedLaunchUrl(List args) async {
    final url = args[0];
    if (!await canLaunch(url)) {
      throw TTYException('can not launch url: $url');
    }
    return launch(url);
  }

  _debug(args) {
    locator<DebugProvider>().addWidget(LispDebugWidget(_lisp));
  }

  _newYear(args) {
    final ss = [
      '鼠年来到掷臂高呼 如意花开美满幸福',
      '太平盛世长命百岁 身体健康光明前途',
      '一帆风顺一生富裕 事业辉煌心畅情舒',
      '步步高升财源广进 家庭美满和谐共处',
      '祝你鼠年开门大吉！',
    ];
    for (var s in ss) {
      locator<SnakebarProvider>().info(s);
    }
  }

  _clear(args) {
    locator<DebugProvider>().clear();
  }

  _openAlice(args) {
    final alice = locator<Alice>();
    Navigator.of(_context).push(
      CupertinoPageRoute(builder: (_) => alice.buildInspector()),
    );
  }

  _print(args) {
    final msg = args[0];
    print(msg);
  }

  _test(LispFrame frame) async {
    // final g = await User().getGrade();
    // return g;
    return NetdiskService().getQuota();
  }

  _rmrf(LispFrame frame) {
    print('sudo rm -rf');
    locator<PersistCookieJar>().deleteAll();
    Hive.deleteFromDisk();
    print('done');
    print('All local data has been wiped out, please restart.');
  }

  _custedWebview(LispFrame frame) {
    final url = frame[0].toString();
    AppRoute(
      title: "Common",
      page: CommonWebPage(url),
    ).go(_context);
  }

  _cookieSet(LispFrame frame) {
    final uri = frame[0].toString().toUri();
    final key = frame[1].toString();
    final value = frame[2].toString();

    final expires = frame.keyword['expires'];
    final maxAge = frame.keyword['max-age'];
    final domain = frame.keyword['domain'];
    final path = frame.keyword['path'] ?? '/';
    final secure = frame.keyword['secure'] == true;
    final httpOnly = frame.keyword['http-only'] == true;

    StringBuffer sb = new StringBuffer();
    sb..write(key)..write("=")..write(value);
    if (expires != null) {
      sb..write("; Expires=")..write(HttpDate.format(expires));
    }
    if (maxAge != null) {
      sb..write("; Max-Age=")..write(maxAge);
    }
    if (domain != null) {
      sb..write("; Domain=")..write(domain);
    }
    if (path != null) {
      sb..write("; Path=")..write(path);
    }
    if (secure) sb.write("; Secure");
    if (httpOnly) sb.write("; HttpOnly");

    final setCookie = sb.toString();
    final cookie = Cookie.fromSetCookieValue(setCookie);
    final cookieJar = locator<PersistCookieJar>();
    cookieJar.saveFromResponse(uri, [cookie]);
    return cookie.toString();
  }
}
