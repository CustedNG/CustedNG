import 'package:custed2/ui/web/web_page.dart';

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
    controller.loadUrl(url: 'https://cust.app/web/exams?ios=true');
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) async {}
}
