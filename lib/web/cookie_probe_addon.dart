import 'package:custed2/core/webview/addon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CookieProbeAddon extends WebviewAddon {
  CookieProbeAddon();

  @override
  final targetPath = '/';

  final controller = CookieProbeController();

  void onPageFinished(InAppWebViewController controller, String url) async {
    final cookie =
        await controller.evaluateJavascript(source: 'document.cookie');
    this.controller.setCookie(cookie);
  }

  @override
  Widget build(InAppWebViewController controller, String url) {
    return CookieProbeWidget(this.controller);
  }
}

class CookieProbeController with ChangeNotifier {
  var cookie = '';

  setCookie(String cookie) {
    this.cookie = cookie;
    notifyListeners();
  }
}

class CookieProbeWidget extends StatefulWidget {
  CookieProbeWidget(this.controller);

  final CookieProbeController controller;

  @override
  _CookieProbeWidgetState createState() => _CookieProbeWidgetState();
}

class _CookieProbeWidgetState extends State<CookieProbeWidget> {
  void onCookieChange() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(onCookieChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(onCookieChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 128),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.controller.cookie ?? 'NO COOKIE'),
          ],
        ),
      ),
    );
  }
}
