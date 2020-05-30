import 'package:custed2/ui/web/web_page.dart';

class StatusWebPage extends WebPage {
  @override
  final title = '状态监测';

  @override
  final canGoBack = false;

  @override
  _StatusWebPageState createState() => _StatusWebPageState();
}

class _StatusWebPageState extends WebPageState {
  @override
  void onCreated() async {
    controller.loadUrl(url: 'https://cust.app/status');
  }
}
