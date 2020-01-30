import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/pages/web_page.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';

class JwWebPage extends WebPage {
  final title = '教务系统';

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

    final url = JwService.baseUrl + '/Student';
    await locator<JwService>().login();
    await loadCookieFor(url);
    controller.loadUrl(url: url);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) {}
}
