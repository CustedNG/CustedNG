import 'package:custed2/core/script.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/config/routes.dart';

class HomeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('查看校历'),
          onPressed: () {
            Navigator.of(context).pop();
            schoolCalendar.go(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('我遇到了 BUG'),
          onPressed: () {
            runScript('bug_report.cl', context);
            Navigator.of(context).pop();
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('取消'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
