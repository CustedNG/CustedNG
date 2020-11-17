import 'package:custed2/core/open.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/web/web_page_action.dart';
import 'package:custed2/web/iecard_addon.dart';
import 'package:custed2/web/iecard_netfee_addon.dart';
import 'package:custed2/web/mysso_addon.dart';
import 'package:custed2/web/self_login_addon.dart';
// import 'package:custed2/web/login_addon.dart';

class CustNavWebPage extends WebPage {
  @override
  final title = 'Cust+';

  final actions = [
    WebPageAction(
      name: '在浏览器中打开',
      handler: (context) async {
        return openUrl('https://cust.cc/');
      },
    ),
  ];

  @override
  _CustNavWebPageState createState() => _CustNavWebPageState();
}

class _CustNavWebPageState extends WebPageState {
  final addons = [
    // SelfLoginAddon(),
    // ProbeAddon('document.cookie'),
    // ProbeAddon('navigator.userAgent'),
    // LoginAddon(),
    MyssoAddon(),
    SelfLoginAddon(),
    IecardAddon(),
    IecardNetFeeAddon(),
  ];

  @override
  void onCreated() async {
    final url = 'https://cust.cc/?custed=1';
    await loadCookieFor(url);
    controller.loadUrl(url: url);

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

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) {}
}
