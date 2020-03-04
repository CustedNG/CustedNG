import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/iecard_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/web/iecard_addon.dart';
import 'package:custed2/web/iecard_netfee_addon.dart';

class IecardWebPage extends WebPage {
  final title = '一卡通';

  @override
  _IecardWebPageState createState() => _IecardWebPageState();
}

class _IecardWebPageState extends WebPageState {
  final addons = [
    IecardAddon(),
    IecardNetFeeAddon(),
  ];

  @override
  void onCreated() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      this.replaceWith(PlaceholderWidget(text: '需要登录'));
      return;
    }

    await IecardService().xRequest('GET', IecardService.userUrl.toUri(),
        maxRedirects: 0, expireTest: (resp) => resp.statusCode != 200);
    final url = IecardService.phoneHomeUrl;
    // await IecardService().login();
    await loadCookieFor(url);
    controller.loadUrl(url: url);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) async {}
}
