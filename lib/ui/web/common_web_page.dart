import 'package:custed2/ui/web/web_page.dart';

class CommonWebPage extends WebPage {
  CommonWebPage(String url) : super(defaultUrl: url);

  final title = 'Common';

  @override
  _CommonWebPageState createState() => _CommonWebPageState();
}

class _CommonWebPageState extends WebPageState {
  @override
  void onCreated() async {
    await loadCookieFor(widget.defaultUrl);
    controller.loadUrl(url: widget.defaultUrl);
  }

  @override
  void onPageStarted(String url) {}

  @override
  void onPageFinished(String url) {}
}
