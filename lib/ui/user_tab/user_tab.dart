import 'package:custed2/config/route.dart';
import 'package:custed2/config/theme.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:provider/provider.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    if (user.isBusy) {
      return PlaceholderWidget(isActive: true);
    }

    final hasProfile = user.profile != null;
    return hasProfile
        ? _buildUserTab(context, user.profile)
        : _buildLoginButton(context);
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: CupertinoButton(
        child: Text('点我登录'),
        color: AppTheme.of(context).btnPrimaryColor,
        onPressed: () => _login(context),
      ),
    );
  }

  Widget _buildUserTab(BuildContext context, UserProfile profile) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: CupertinoSettings(
        items: <Widget>[
          CSHeader('用户'),
          CSWidget(_buildUserInfo(context, profile)),
          CSControl('四六级照片', Icon(CupertinoIcons.right_chevron)),
          CSHeader('课表'),
          CSControl('将课表设为首页', _buildDefaultTabSwitch(context)),
          CSHeader(''),
          CSButton(CSButtonType.DEFAULT_CENTER, "重新登录", () => _login(context)),
          CSButton(CSButtonType.DESTRUCTIVE, "退出登录", () => _logout(context))
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProfile profile) {
    return Row(
      children: <Widget>[
        Text(profile.displayName),
      ],
    );
  }

  Widget _buildDefaultTabSwitch(BuildContext context) {
    final setting = locator<SettingStore>();
    return ValueListenableBuilder(
      valueListenable: setting.useScheduleAsHome.listenable(),
      builder: (context, value, widget) {
        return CupertinoSwitch(
          value: value,
          onChanged: (value) => setting.useScheduleAsHome.put(value),
        );
      },
    );
  }

  void _login(BuildContext context) {
    loginPage.go(context);
  }

  void _logout(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.clearProfileData();
  }
}
