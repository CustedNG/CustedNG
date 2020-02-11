import 'package:alice/alice.dart';
import 'package:custed2/core/lisp/lisp.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/tty/exception.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/store/lisp_store.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:url_launcher/url_launcher.dart';

class TTYEngine {
  // 1. notice banner update (presistence)
  // 2. async support
  // 3. (alice) -> alice (alias: simple form)
  // 4. set boot script

  TTYEngine(this.executer, this.context) {
    // Reference: https://docs.racket-lang.org/racket-cheat/index.html
    
    _lisp.def('custed-build', 0, _custedBuild);
    _lisp.def('custed-name', 0, _custedName);

    _lisp.def('custed-min-build', 1, _custedMinBuild);
    _lisp.def('custed-max-build', 0, _custedMaxBuild);

    _lisp.def('custed-set', 2, _custedSet);
    _lisp.def('custed-get', 1, _custedGet);

    _lisp.def('custed-wait', 1, _custedWait);
    _lisp.def('custed-notify', 1, _custedNotify);
    _lisp.def('custed-launch-url', 1, _custedLaunchUrl);

    _lisp.def('custed-launch-url', 1, _custedLaunchUrl);

    _lisp.def('-', -1, _custedLegacy);
    _lisp.def('new-year', 0, _newYear);

    _lisp.def('clear', 0, _clear);
    _lisp.def('c', 0, _clear);

    _lisp.def('alice', 0, _openAlice);
    _lisp.def('i', 0, _openAlice);

    _lisp.def('print', 1, _print);
  }

  final TTYExecuter executer;
  final BuildContext context;
  final _store = LispStore();
  final _lisp = lispMakeInterp();

  Future<void> init() async {
    await _store.init();
  }

  Future eval(String source) async {
    return _lisp.evalString(source, null);
  }

  _custedMinBuild(List args) {
    final minBuild = args[0];
    if (BuildData.build < minBuild) {
      throw TTYException('min build: $minBuild');
    }
  }

  _custedMaxBuild(List args) {
    final minBuild = args[0];
    if (BuildData.build > minBuild) {
      throw TTYException('max build: $minBuild');
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
    final cmd = (args[0] as LispCell).car;
    return executer.executeLegacy(cmd, context);
  }

  _custedNotify(List args) {
    final notification = args[0];
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
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (_) => alice.buildInspector()),
    );
  }

  _print(args) {
    final msg = args[0];
    print(msg);
  }
}
