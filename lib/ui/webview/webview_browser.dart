import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:custed2/ui/webview/plugin_iecard.dart';
import 'package:custed2/ui/webview/plugin_nav.dart';
import 'package:custed2/ui/webview/plugin_remote.dart';
import 'package:custed2/ui/webview/plugin_mysso.dart';
import 'package:custed2/ui/webview/plugin_netdisk.dart';
import 'package:custed2/ui/webview/plugin_portal.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:flutter/material.dart';

class WebviewBrowser extends StatelessWidget {
  WebviewBrowser(this.url, {this.showBottom = true});

  final String url;
  final bool showBottom;

  @override
  Widget build(BuildContext context) {
    return Webview2(
      url: url,
      onCreated: onCreated,
      showBottom: showBottom,
      invalidUrlRegex: 'custed-target=blank',
      onLoadAborted: (controller, url) {
        if (url.contains('custed-target=blank')) {
          openUrl(url);
        }
      },
      plugins: [
        PluginForMysso(),
        PluginForPortal(),
        PluginForIecard(),
        PluginForNetdisk(),
        PluginFromRemote(),
        PluginForNav()
      ],
    );
  }

  void onCreated(Webview2Controller controller) async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      return;
    }

    await loadCookieFor(controller, WrdvpnService.baseUrl);

    await loadCookieFor(controller, MyssoService.loginUrl);
    await loadCookieFor(controller, MyssoService.loginUrl,
        urlOverride:
            'http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118/cas/login');

    await loadCookieFor(controller, WebvpnService.baseUrl);
    await loadCookieFor(controller, WebvpnService.baseUrl,
        urlOverride: WebvpnService.baseUrlInsecure);
  }

  Future<void> loadCookieFor(
    Webview2Controller controller,
    String url, {
    String urlOverride,
  }) async {
    final rawCookies =
        await locator<PersistCookieJar>().loadForRequest(url.uri);
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
    await controller.setCookies(cookies);
  }
}
