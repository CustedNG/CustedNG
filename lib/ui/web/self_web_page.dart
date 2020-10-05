import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/web/web_page_action.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/web/jw_eval_addon.dart';
import 'package:custed2/web/self_login_addon.dart';

class SelfWebPage extends WebPage {
  @override
  final title = '校园网';

  final actions = [
    WebPageAction(
      name: '在浏览器中打开',
      handler: (context) async {
        return openUrl('http://self-cust-edu-cn.webvpn.cust.edu.cn:8118/');
      },
    ),
  ];

  @override
  _SelfWebPageState createState() => _SelfWebPageState();
}

class _SelfWebPageState extends WebPageState {
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
    final url = 'http://self-cust-edu-cn.webvpn.cust.edu.cn:8118/';
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
