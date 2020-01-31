import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/web/tiku_addon.dart';

class TikuWebPage extends WebPage {
  @override
  final title = '考试题库';

  @override
  final canGoBack = false;

  @override
  _ExamRoomWebPageState createState() => _ExamRoomWebPageState();
}

class _ExamRoomWebPageState extends WebPageState {
  final addons = [
    TikuAddon(),
  ];

  @override
  void onCreated() async {
    controller.loadUrl(url: 'https://exam.tusi.site');
  }
}
