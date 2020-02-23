import 'package:custed2/config/routes.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/user_tab/netdisk_percent.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:provider/provider.dart';

class NetdiskPage extends StatelessWidget {
  final netdisk = locator<NetdiskProvider>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _buildRoot(context),
    );
  }

  Widget _buildRoot(BuildContext context) {
    final netdisk = Provider.of<NetdiskProvider>(context);
    if (netdisk.isBusy) {
      return PlaceholderWidget(isActive: true);
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return CupertinoSettings(
      items: [
        CSSpacer(),
        CSWidget(_buildQuota(context), height: 70),
        CSSpacer(),
        CSButton(CSButtonType.DEFAULT_CENTER, '一键登录网盘', () {
          netdiskWebPage.go(context);
        }),
      ],
    );
  }

  Widget _buildQuota(BuildContext context) {
    if (netdisk.quota == null) {
      return Text('无数据');
    }

    final text = '已用 '
        '${netdisk.quota.used.withSizeUnit()}/'
        '${netdisk.quota.quota.withSizeUnit()}';
    final textRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('NetDisk'),
        Text(text),
      ],
    );
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        textRow,
        SizedBox(height: 7),
        NetdiskPercent(
          netdisk.quota.used,
          netdisk.quota.quota,
          height: 15,
        ),
      ],
    );
  }
}
