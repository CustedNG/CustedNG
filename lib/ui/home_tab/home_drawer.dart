import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/config/routes.dart';
import 'package:custed2/constants.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/pages/kv_table_page.dart';
import 'package:custed2/ui/webview/webview_login.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget{
  final version;
  final myTheme;
  final UserProvider user;

  const HomeDrawer({
    Key key, this.version, this.myTheme, this.user
  }) : super(key: key);

  Widget _buildUserHeader(bool isLoggedIn) {
    return UserAccountsDrawerHeader(
      accountName:
      Text(isLoggedIn ? ' ' + user.profile.displayName : '请登录'),
      accountEmail:
      Text(isLoggedIn ? user.profile.department : '(´･ω･`)'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/icon/custed_lite.png'),
      ),
    );
  }

  Widget _buildUserEntries(BuildContext context, bool isLoggedIn) {
    final version = BuildData.modifications != 0
        ? '${BuildData.build}(+${BuildData.modifications}f)'
        : '${BuildData.build}';
    Map<String, String> infoMap = {
      '名称': BuildData.name,
      '版本': version,
      'Engine': BuildData.engine,
      '构建日期': BuildData.buildAt,
    };

    return Column(
      children: [
        isLoggedIn ? ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text('四六级照片'),
          onTap: () {
            locator<CetAvatarProvider>().getAvatar();
            cetAvatarPage.go(context);
          },
        ) : Container(),
        isLoggedIn ? ListTile(
          leading: Icon(Icons.cloud),
          title: Text('校园网盘'),
          onTap: () {
            locator<NetdiskProvider>().getQuota();
            netdiskPage.go(context);
          },
        ) : Container(),
        isLoggedIn ? Divider() : Container(),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('版本信息'),
          onTap: () => AppRoute(
            title: '版本信息',
            page: KVTablePage('版本信息', infoMap)
          ).go(context),
        ),
        ListTile(
          leading: Icon(Icons.code),
          title: Text('更新日志'),
          onTap: () => AppRoute(
            title: '更新日志',
            page: KVTablePage('更新日志', locator<AppProvider>().changeLog),
          ).go(context),
        ),
        AboutListTile(
          icon: Icon(Icons.text_snippet),
          child: Text('开源证书'),
          applicationName: appName,
          applicationVersion: version,
          applicationIcon: Image.asset(
            custedIconPath,
            width: 64.0,
            height: 64.0,
          ),
          aboutBoxChildren: <Widget>[
            Text('By Toast Studio.\nAll rights reserved.')
          ],
        ),
      ],
    );
  }

  Widget _buildLoginEntries(BuildContext context, bool isLoggedIn) {
    return Column(
      children: [
        isLoggedIn ? ListTile(
          leading: Icon(Icons.login),
          title: Text('重新登录'),
          onTap: () async {
            await WebviewLogin.begin(context);
          },
        ) : ListTile(
          leading: Icon(Icons.web),
          title: Text('统一登录'),
          onTap: () async {
            await WebviewLogin.begin(context);
          },
        ),
        if (isLoggedIn) ListTile(
          leading: Icon(Icons.logout),
          title: Text('退出登录'),
          onTap: () async {
            await locator<PersistCookieJar>().deleteAll();
            await user.logout();
          },
        ) 
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = user.loggedIn;

    return Drawer(
        child: ListView(
            padding: EdgeInsets.only(),
            children: <Widget>[
              _buildUserHeader(isLoggedIn),
              _buildUserEntries(context, isLoggedIn),
              Divider(),
              _buildLoginEntries(context, isLoggedIn)
            ]
        )
    );
  }
}