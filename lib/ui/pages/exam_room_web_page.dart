import 'package:custed2/service/iecard_service.dart';
import 'package:custed2/ui/pages/web_page.dart';
import 'package:custed2/web/iecard_addon.dart';
import 'package:custed2/web/iecard_netfee_addon.dart';

class ExamRoomWebPage extends WebPage {
  @override
  final title = '考场查询';

  @override
  final canGoBack = false;

  @override
  _ExamRoomWebPageState createState() => _ExamRoomWebPageState();
}

class _ExamRoomWebPageState extends WebPageState {
  final addons = [];

  @override
  void onCreated() async {
    controller.loadUrl(url: 'https://cust.xuty.cc/web/exams?ios=true');
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) async {}
}
