import 'package:connectivity/connectivity.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/update/update_progress_page.dart';
import 'package:flutter/cupertino.dart';

class UpdateNoticePage extends StatelessWidget {
  UpdateNoticePage(this.update);

  final CustedUpdate update;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      color: theme.backgroundColor,
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
        // Text('本次需要下载 ${(update.file.size / 1024).toStringAsFixed(2)} MB')
      ],
    );
  }

  void doUpdate(BuildContext context) {
    Navigator.pop(context);
    AppRoute(
      title: '更新中',
      page: UpdateProgressPage(update),
    ).go(context, rootNavigator: true);
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoButton.filled(
          child: Text(
            '开始更新',
            style: TextStyle(color: CupertinoColors.white),
          ),
          onPressed: () async {
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile) {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  content: Text('你正在使用移动数据网络。继续下载将会消耗流量'),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('继续'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        doUpdate(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('取消'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            } else {
              doUpdate(context);
            }
          },
        ),
        CupertinoButton(
          child: Text('我不'),
          onPressed: () {
            final settings = locator<SettingStore>();
            settings.ignoreUpdate.put(update.build);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
