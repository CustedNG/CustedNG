import 'package:custed2/ui/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';

class WebProgress extends StatefulWidget {
  final controller = WebProgressController();

  @override
  _WebProgressState createState() => _WebProgressState();
}

class _WebProgressState extends State<WebProgress> {
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
    return Container(
      color: CupertinoColors.white,
      constraints: BoxConstraints.expand(),
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 130,
        height: 10,
        child: ProgressBar(
          widget.controller.current,
          widget.controller.total,
          borderWidth: 1,
        ),
      ),
    );
  }
}

class WebProgressController extends ChangeNotifier {
  int current = 0;
  int total = 1;

  update(int current, int total) {
    this.current = current;
    this.total = total;
    notifyListeners();
  }
}
