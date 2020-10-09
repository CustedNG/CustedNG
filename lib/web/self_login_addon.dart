import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SelfLoginAddon extends WebviewAddon {
  SelfLoginAddon();

  @override
  final targetPath = '/nav_login';

  String jsSetAccount(String account) => '''
    ;(function() {
      document.querySelector('input[id=account]').value = '$account';
      document.querySelector('input[type=submit]').disabled = false;
    })();
  ''';

  void onPageFinished(InAppWebViewController controller, String url) async {
    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();

    if (username != null) {
      controller.evaluateJavascript(source: jsSetAccount(username));
    }
  }

  @override
  Widget build(InAppWebViewController controller, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('提示: 帐号为一卡通号'),
        Text('密码默认为身份证号后六位'),
      ],
    );
  }
}
