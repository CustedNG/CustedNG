import 'package:custed2/config/routes.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetdiskPage extends StatelessWidget {
  final netdisk = locator<NetdiskProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        context: context,
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
    final user = Provider.of<UserProvider>(context);
    if (user.isBusy) {
      return PlaceholderWidget(isActive: true);
    }
    return Column(
      children: [
        SizedBox(height: 20.0),
        SettingItem(
          title: '个人文件',
          titleStyle:
              TextStyle(color: isDark(context) ? Colors.white : Colors.black),
          isShowArrow: false,
          content: netdisk.quota != null
              ? '已用 '
                  '${netdisk.quota.used.withSizeUnit()}/'
                  '${netdisk.quota.quota.withSizeUnit()}'
              : (user.loggedIn ? '无数据' : '请登录'),
        ),
        SizedBox(height: 30.0),
        MaterialButton(
            child: Text('一键登录网盘'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () => netdiskWebPage.popup(context)),
      ],
    );
  }
}
