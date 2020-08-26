import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/web/web_page_action.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
// import 'package:custed2/web/cookie_probe_addon.dart';
import 'package:custed2/web/jw_eval_addon.dart';

Future<String> _getJwPresignedUrl() async {
  final user = locator<UserProvider>();
  if (!user.loggedIn) {
    return 'https://jwgl.cust.edu.cn/';
  }

  final ticket = await MyssoService().getTicketForJw();
  final jwUrl = 'https://jwgl.cust.edu.cn/welcome?ticket=$ticket';
  final url = await WrdvpnService().getBypassUrl(jwUrl);
  return url;
}

class JwWebPage extends WebPage {
  @override
  final title = '教务系统';

  final actions = [
    WebPageAction(
      name: '在浏览器中打开',
      handler: (context) async {
        final url = await _getJwPresignedUrl();
        openUrl(url);
        // print(url);
      },
    ),
  ];

  @override
  _JwWebPageState createState() => _JwWebPageState();
}

class _JwWebPageState extends WebPageState {
  final addons = [
    JwEvalAddon(),
    // CookieProbeAddon(),
  ];

  @override
  void onCreated() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      this.replaceWith(PlaceholderWidget(text: '需要登录'));
      return;
    }

    // final ticket = await MyssoService().getTicketForJw();
    // await MyssoService().getTicketForJw();
    // await MyssoService().login();
    // final url = 'https://jwgl.cust.edu.cn/welcome';
    final url = await _getJwPresignedUrl();
    await loadCookieFor(JwService.baseUrl);
    await loadCookieFor(MyssoService.loginUrl);
    await loadCookieFor(WrdvpnService.baseUrl);
    // await loadCookieFor(url);
    controller.loadUrl(url: url);
    // controller.loadUrl(url: 'https://mysso.cust.edu.cn/cas/login');
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) {}
}
