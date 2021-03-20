import 'package:custed2/config/routes.dart';
import 'package:custed2/core/store/presistent_store.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
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
            onPressed: () => loginPage.popup(context),
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
    final darkModeStatus = ['自动', '开', '关'][setting.darkMode.fetch()];

    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        middle: NavbarText('账户'),
      ),
      backgroundColor: CupertinoColors.lightBackgroundGray,
      child: CupertinoSettings(
        items: <Widget>[
          CSHeader('用户'),
          CSWidget(_buildUserInfo(context, profile), height: 75),
          _buildLink(context, '四六级照片', () {
            locator<CetAvatarProvider>().getAvatar();
            cetAvatarPage.go(context);
          }),
          // _buildLink(context, '网盘与备份', () {
          _buildLink(context, '网盘', () {
            locator<NetdiskProvider>().getQuota();
            netdiskPage.go(context);
          }, isLast: true),
          CSHeader('设置'),
          CSControl(
            nameWidget: Text('将课表设为首页'),
            contentWidget: _buildSwitch(context, setting.useScheduleAsHome),
          ),
          CSControl(
            nameWidget: Text('显示非当前周课程'),
            contentWidget: _buildSwitch(context, setting.showInactiveLessons),
          ),
          CSControl(
            nameWidget: Text('绩点不计选修'),
            contentWidget:
                _buildSwitch(context, setting.dontCountElectiveCourseGrade),
          ),
          // CSControl(
          //   nameWidget: Text('成绩安全模式'),
          //   contentWidget: _buildSwitch(
          //     context,
          //     setting.gradeSafeMode,
          //     onChanged: (value) {
          //       if (value == true) {
          //         showCupertinoDialog(
          //           context: context,
          //           builder: (context) {
          //             return CupertinoAlertDialog(
          //               content: Text('安全模式开启成功\n'
          //                   '你可以在五分钟内放心地展示你的成绩。\n'
          //                   '避免与父母争吵影响学习心情和家庭和谐\n'
          //                   '另：此功能对好学生无效。'),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
          _buildLink(context, '黑暗模式', () {
            darkModePage.go(context);
          }, isLast: true, prompt: darkModeStatus),
          // CSHeader('成绩'),
          CSHeader(''),
          CSButton(CSButtonType.DEFAULT_CENTER, "重新登录", () => _login(context)),
          CSButton(CSButtonType.DESTRUCTIVE, "退出登录", () => _logout(context)),
          SizedBox(height: 15)
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
        child: DarkModeFilter(
          child: Image(image: ImageRes.defaultAvatar),
        ),
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
        Text(
          profile.displayName,
          style: TextStyle(
            color: isDark(context) ? Colors.white : Colors.black,
          ),
        ),
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

  Widget _buildSwitch(BuildContext context, StoreProperty<bool> prop,
      {bool Function(bool value) onChanged}) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, value, widget) {
        return DarkModeFilter(
          child: CupertinoSwitch(
            value: value,
            onChanged: (value) {
              if (onChanged == null || onChanged(value) == true) {
                prop.put(value);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildLink(
    BuildContext context,
    String name,
    void onPressed(), {
    bool isLast = false,
    String prompt,
  }) {
    final content = prompt != null
        ? Container(
            padding: EdgeInsets.only(right: 5),
            child: Text(
              prompt,
              style: TextStyle(color: CupertinoColors.systemGrey2),
            ),
          )
        : Icon(
            CupertinoIcons.right_chevron,
            color: CupertinoColors.systemGrey2,
          );
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      child: CSControl(
        nameWidget: Text(name),
        contentWidget: content,
        addPaddingToBorder: !isLast,
      ),
      onPressed: onPressed,
    );
  }

  void _login(BuildContext context) {
    loginPage.popup(context);
  }

  void _logout(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    user.logout();
  }
}
