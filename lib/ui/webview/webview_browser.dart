import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:custed2/ui/webview/plugin_iecard.dart';
import 'package:custed2/ui/webview/plugin_mysso.dart';
import 'package:custed2/ui/webview/plugin_netdisk.dart';
import 'package:custed2/ui/webview/plugin_portal.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class WebviewBrowser extends StatelessWidget {
  WebviewBrowser(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Webview2(
      url: url,
      onCreated: onCreated,
      plugins: [
        PluginForMysso(),
        PluginForPortal(),
        PluginForIecard(),
        PluginForNetdisk(),
      ],
    );
  }

  void onCreated() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      return;
    }

    await WebvpnService().login();
    await WrdvpnService().login();
    await loadCookieFor(WrdvpnService.baseUrl);

    await loadCookieFor(MyssoService.loginUrl);
    await loadCookieFor(MyssoService.loginUrl,
        urlOverride:
            'http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/cas/login');

    await loadCookieFor(WebvpnService.baseUrl);
    await loadCookieFor(WebvpnService.baseUrl,
        urlOverride: WebvpnService.baseUrlInsecure);
  }

  Future<void> loadCookieFor(String url, {String urlOverride}) async {
    final rawCookies = locator<PersistCookieJar>().loadForRequest(url.toUri());
    final cookies = <Cookie>[];

    final uri = Uri.tryParse(url);
    final uriOverride = urlOverride != null ? Uri.tryParse(urlOverride) : null;

    if (uri == null) {
      print('no cookie for bad url $url');
    }

    for (var rawCookie in rawCookies) {
      final cookie = Cookie(rawCookie.name, rawCookie.value)
        ..domain = uriOverride?.host ?? uri.host
        ..path = uriOverride?.path ?? rawCookie.path
        ..expires = rawCookie.expires
        ..maxAge = rawCookie.maxAge
        ..httpOnly = rawCookie.httpOnly
        ..secure = false;

      cookies.add(cookie);
    }

    print('cookies $url $cookies');
    // final uriOverride = urlOverride?.toUri();
    await WebviewCookieManager().setCookies(cookies);
  }
}
