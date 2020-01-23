import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';

class CbsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: PlaceholderWidget('Custed Backup Service'),
    );
  }
}
