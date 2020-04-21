import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';

class JwWebPage extends WebPage {
  @override
  final title = '教务系统';

  @override
  final String userAgent = UserAgent.chromeUA;

  @override
  _JwWebPageState createState() => _JwWebPageState();
}

class _JwWebPageState extends WebPageState {
  @override
  void onCreated() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      this.replaceWith(PlaceholderWidget(text: '需要登录'));
      return;
    }

    await locator<JwService>().login();
    final url = JwService.baseUrl + '/Student';
    await loadCookieFor(url);
    controller.loadUrl(url: url);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) {}
}
