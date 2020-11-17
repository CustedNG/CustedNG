import 'package:custed2/ui/web/web_page.dart';

class Tiku2WebPage extends WebPage {
  @override
  final title = '考试题库';

  @override
  final canGoBack = false;

  @override
  _ExamRoomWebPageState createState() => _ExamRoomWebPageState();
}

class _ExamRoomWebPageState extends WebPageState {
  final addons = [
    // Tiku2Addon(),
  ];

  @override
  void onCreated() async {
    controller.loadUrl(url: 'https://tiku.lacus.site/?custed=1');
  }
}
