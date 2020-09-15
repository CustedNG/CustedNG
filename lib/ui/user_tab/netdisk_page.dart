import 'package:custed2/config/routes.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/user_tab/netdisk_percent.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:provider/provider.dart';

class NetdiskPage extends StatelessWidget {
  final netdisk = locator<NetdiskProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        context: context,
        leading: GestureDetector(
          child: BackIcon(),
          onTap: () => Navigator.pop(context),
        ),
        middle: NavbarText('网盘'),
      ),
      body: _buildRoot(context),
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
    return Column(
      children: [
        SizedBox(height: 20.0),
        SettingItem(
          title: '个人文件',
          titleStyle:
              TextStyle(color: isDark(context) ? Colors.white : Colors.black),
          isShowArrow: false,
          content: '已用 '
              '${netdisk.quota.used.withSizeUnit()}/'
              '${netdisk.quota.quota.withSizeUnit()}',
        ),
        SizedBox(height: 30.0),
        MaterialButton(
            child: Text('一键登录网盘'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () => netdiskWebPage.go(context)),
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
        Text(netdisk.quota.type),
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
        SizedBox(height: 12),
      ],
    );
  }
}
