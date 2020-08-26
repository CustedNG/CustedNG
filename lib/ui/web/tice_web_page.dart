import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/web/web_page_action.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/web/self_login_addon.dart';

class TiceWebPage extends WebPage {
  @override
  final title = '体测成绩';

  final actions = [
    WebPageAction(
      name: '在浏览器中打开',
      handler: (context) async {
        return openUrl('http://jtb-cust-edu-cn.webvpn.cust.edu.cn:8118/tz/');
      },
    ),
  ];

  @override
  TiceWebPageState createState() => TiceWebPageState();
}

class TiceWebPageState extends WebPageState {
  final addons = [
    SelfLoginAddon(),
  ];

  @override
  void onCreated() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      this.replaceWith(PlaceholderWidget(text: '需要登录'));
      return;
    }

    await WebvpnService().login();
    final url = 'http://jtb-cust-edu-cn.webvpn.cust.edu.cn:8118/tz/';
    await loadCookieFor(MyssoService.loginUrl);
    await loadCookieFor(WebvpnService.baseUrl);
    await loadCookieFor(url);
    controller.loadUrl(url: url);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) {}
}
