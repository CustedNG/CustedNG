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
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final darkModeStatus = ['自动', '开', '关'][setting.darkMode.fetch()];
    final settingTextStyle =
        TextStyle(color: isDark(context) ? Colors.white : Colors.black);
    final theme = AppTheme.of(context);

    return Scaffold(
        backgroundColor: theme.homeBackgroundColor,
        appBar: NavBar.material(
          context: context,
          middle: NavbarText('账户'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: false,
                  child: Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 3 / 1,
                        child: Image.asset('assets/bg/abstract-dark.jpg',
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                          top: 30,
                          left: 30,
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: DarkModeFilter(
                                    child: Image(
                                        height: 50,
                                        width: 50,
                                        image: ImageRes.defaultAvatar),
                                  )),
                              SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    profile.displayName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    profile.department,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 20.0),
                  Text('用户'),
                  SizedBox(height: 10.0),
                  SettingItem(
                    title: '四六级照片',
                    titleStyle: settingTextStyle,
                    onTap: () {
                      locator<CetAvatarProvider>().getAvatar();
                      cetAvatarPage.go(context);
                    },
                  ),
                  SettingItem(
                    title: '网盘',
                    titleStyle: settingTextStyle,
                    onTap: () {
                      locator<NetdiskProvider>().getQuota();
                      netdiskPage.go(context);
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text('设置'),
                  SizedBox(height: 10.0),
                  SettingItem(
                    title: '将课表设置为首页',
                    titleStyle: settingTextStyle,
                    isShowArrow: false,
                    rightBtn: _buildSwitch(context, setting.useScheduleAsHome),
                  ),
                  SettingItem(
                    title: '显示非当前周课程',
                    titleStyle: settingTextStyle,
                    isShowArrow: false,
                    rightBtn:
                        _buildSwitch(context, setting.showInactiveLessons),
                  ),
                  SettingItem(
                    title: '绩点不计选修',
                    titleStyle: settingTextStyle,
                    isShowArrow: false,
                    rightBtn: _buildSwitch(
                        context, setting.dontCountElectiveCourseGrade),
                  ),
                  SettingItem(
                    title: '黑暗模式',
                    titleStyle: settingTextStyle,
                    content: darkModeStatus,
                    onTap: () => darkModePage.go(context),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          child: Text('重新登录'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () => _login),
                      SizedBox(width: 40.0),
                      MaterialButton(
                          child: Text('退出登录'),
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () => _logout),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildSwitch(BuildContext context, StoreProperty<bool> prop) {
    return Positioned(
        right: 0,
        child: ValueListenableBuilder(
          valueListenable: prop.listenable(),
          builder: (context, value, widget) {
            return DarkModeFilter(
              child: Switch(
                  value: value, onChanged: (value) => prop.put(value)),
            );
          },
        )
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
