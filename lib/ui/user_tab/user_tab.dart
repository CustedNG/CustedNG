import 'package:custed2/config/routes.dart';
import 'package:custed2/config/theme.dart';
import 'package:custed2/core/store/presistent_store.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
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

    return user.loggedIn
        ? _buildUserTab(context, user.profile)
        : _buildLoginButton(context);
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoButton.filled(
            child: Text('统一认证登录'),
            onPressed: () => loginPage.go(context),
          ),
          SizedBox(height: 20),
          Text(
            '或',
            style: TextStyle(color: CupertinoColors.inactiveGray),
          ),
          CupertinoButton(
            child: Text('传统登录'),
            onPressed: () => loginPageLegacy.go(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTab(BuildContext context, UserProfile profile) {
    final setting = locator<SettingStore>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: CupertinoSettings(
        items: <Widget>[
          CSHeader('用户'),
          CSWidget(_buildUserInfo(context, profile), height: 75),
          _buildLink(context, '四六级照片', () {
            locator<CetAvatarProvider>().getAvatar();
            cetAvatarPage.go(context);
          }),
          _buildLink(context, '网盘与备份', () {
            locator<NetdiskProvider>().getQuota();
            netdiskPage.go(context);
          }),
          CSHeader('课表'),
          CSControl(
            '将课表设为首页',
            _buildSwitch(context, setting.useScheduleAsHome),
          ),
          CSControl(
            '显示非当前周课程',
            _buildSwitch(context, setting.showInactiveLessons),
          ),
          CSHeader(''),
          CSButton(CSButtonType.DEFAULT_CENTER, "重新登录", () => _login(context)),
          CSButton(CSButtonType.DESTRUCTIVE, "退出登录", () => _logout(context)),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProfile profile) {
    final theme = AppTheme.of(context);
    final avatar = Container(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(image: ImageRes.defaultAvatar),
      ),
    );
    final departmentText = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: theme.textColor.withAlpha(130),
    );
    final desc = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(profile.displayName),
        SizedBox(height: 3),
        Text(profile.department, style: departmentText),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[avatar, SizedBox(width: 10), desc],
      ),
    );
  }

  Widget _buildSwitch(BuildContext context, StoreProperty<bool> prop) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, value, widget) {
        return CupertinoSwitch(
            value: value, onChanged: (value) => prop.put(value));
      },
    );
  }

  Widget _buildLink(BuildContext context, String name, void onPressed()) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      child: CSControl(name, Icon(CupertinoIcons.right_chevron)),
      onPressed: onPressed,
    );
  }

  void _login(BuildContext context) {
    loginPage.go(context);
  }

  void _logout(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.logout();
  }
}
