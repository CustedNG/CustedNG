import 'package:custed2/core/webview/addon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProbeAddon extends WebviewAddon {
  ProbeAddon(this.expression);

  final String expression;

  @override
  final targetPath = '/';

  final controller = ProbeController();

  void onPageFinished(InAppWebViewController controller, String url) async {
    final data = await controller.evaluateJavascript(source: expression);
    this.controller.setData(data);
  }

  @override
  Widget build(InAppWebViewController controller, String url) {
    return ProbeWidget(this.controller);
  }
}

class ProbeController with ChangeNotifier {
  var data = '';

  setData(String data) {
    this.data = data;
    notifyListeners();
  }
}

class ProbeWidget extends StatefulWidget {
  ProbeWidget(this.controller);

  final ProbeController controller;

  @override
  ProbeWidgetState createState() => ProbeWidgetState();
}

class ProbeWidgetState extends State<ProbeWidget> {
  void onDataChange() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(onDataChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(onDataChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print(widget.controller.data);
      },
      child: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide())),
        constraints: BoxConstraints(maxHeight: 128),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.controller.data ?? 'NO DATA'),
            ],
          ),
        ),
      ),
    );
  }
}
