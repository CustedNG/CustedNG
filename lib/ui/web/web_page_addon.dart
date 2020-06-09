import 'package:flutter/cupertino.dart';

class WebPageAddon extends StatefulWidget {
  WebPageAddon(this.controller);

  final WebPageAddonController controller;

  @override
  _WePagebAddonState createState() => _WePagebAddonState();
}

class _WePagebAddonState extends State<WebPageAddon> {
  @override
  void initState() {
    widget.controller.addListener(onChange);
    super.initState();
  }

  void onChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.controller.children,
    );
  }
}

class WebPageAddonController extends ChangeNotifier {
  var children = <Widget>[];

  update(List<Widget> children) {
    this.children = children;
    notifyListeners();
  }
}
