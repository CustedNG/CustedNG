import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';

class WebProgress extends StatefulWidget {
  WebProgress(this.controller);

  final WebProgressController controller;

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
    return WebProgressLayer(
      widget.controller.current ?? 0,
      widget.controller.total ?? 1,
    );
  }
}

class WebProgressLayer extends StatelessWidget {
  WebProgressLayer(this.current, this.total);

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      color: theme.backgroundColor,
      constraints: BoxConstraints.expand(),
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 130,
        height: 10,
        child: ProgressBar(current, total, borderWidth: 1),
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
