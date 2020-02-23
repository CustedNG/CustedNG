import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/netdisk_service.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/web/netdisk_addon.dart';

class NetdiskWebPage extends WebPage {
  @override
  final title = '网盘';

  @override
  final canGoBack = false;

  @override
  _NetdiskWebPageState createState() => _NetdiskWebPageState();
}

class _NetdiskWebPageState extends WebPageState {
  final addons = [
    NetdiskAddon(),
  ];

  @override
  void onCreated() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      this.replaceWith(PlaceholderWidget(text: '需要登录'));
      return;
    }

    final netdisk = locator<NetdiskService>();
    final loginResult = await netdisk.login();

    if (!loginResult.ok) {
      this.replaceWith(PlaceholderWidget(text: '登录失败'));
      return;
    }

    final loginUrl = loginResult.data;
    await loadCookieFor(loginUrl);
    controller.loadUrl(url: loginUrl);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) async {}

  @override
  void onDownloadStart(String url) {
    final snake = locator<SnakebarProvider>();
    snake.info('下载功能准备中');
  }
}
