import 'package:custed2/service/iecard_service.dart';
import 'package:custed2/ui/pages/web_page.dart';
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
    await IecardService().login();
    final url = IecardService.phoneHomeUrl;
    await loadCookieFor(url);
    controller.loadUrl(url: url);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) async {
  }
}
