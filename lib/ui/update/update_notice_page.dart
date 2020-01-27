import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/update/update_progress_page.dart';
import 'package:flutter/cupertino.dart';

class UpdateNoticePage extends StatelessWidget {
  UpdateNoticePage(this.update);

  final CustedUpdate update;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildMsg(context),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildMsg(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: <Widget>[
        Text('有更新可用', style: textStyle),
        SizedBox(height: 10),
        Text('使用旧版本可能导致某些功能无法使用'),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoButton.filled(
          child: Text('开始更新'),
          onPressed: () {
            Navigator.pop(context);
            AppRoute(
              title: '更新中',
              page: UpdateProgressPage(update),
            ).go(context, rootNavigator: true);
          },
        ),
        CupertinoButton(
          child: Text('我不'),
          onPressed: () {
            // final settings = locator<SettingStore>();
            // settings.ignoreUpdate =
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
