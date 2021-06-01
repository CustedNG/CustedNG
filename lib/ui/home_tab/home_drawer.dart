import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/config/routes.dart';
import 'package:custed2/constants.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/pages/kv_table_page.dart';
import 'package:custed2/ui/pages/login_page_legacy.dart';
import 'package:custed2/ui/webview/webview_login.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget{
  final version;
  final myTheme;
  final UserProvider user;

  const HomeDrawer({
    Key key, this.version, this.myTheme, this.user
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool showRealUI = locator<AppProvider>().showRealUI;

  Widget _buildUserHeader(bool isLoggedIn) {
    return UserAccountsDrawerHeader(
      accountName:
      Text(isLoggedIn ? ' ' + widget.user.profile.displayName : '请登录'),
      accountEmail:
      Text(isLoggedIn ? widget.user.profile.department : '(´･ω･`)'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/icon/custed_lite.png'),
      ),
    );
  }

  Widget _buildUserEntries(BuildContext context, bool isLoggedIn, Color color) {
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
        (isLoggedIn && showRealUI) ? ListTile(
          leading: Icon(Icons.photo_camera, color: color),
          title: Text('四六级照片'),
          onTap: () {
            locator<CetAvatarProvider>().getAvatar();
            cetAvatarPage.go(context);
          },
        ) : Container(),
        (isLoggedIn && showRealUI) ? ListTile(
          leading: Icon(Icons.cloud, color: color),
          title: Text('校园网盘'),
          onTap: () {
            locator<NetdiskProvider>().getQuota();
            netdiskPage.go(context);
          },
        ) : Container(),
        (isLoggedIn && showRealUI) ? Divider() : Container(),
        ListTile(
          leading: Icon(Icons.info, color: color),
          title: Text('版本信息'),
          onTap: () => AppRoute(
            title: '版本信息',
            page: KVTablePage('版本信息', infoMap)
          ).go(context),
        ),
        ListTile(
          leading: Icon(Icons.code, color: color),
          title: Text('更新日志'),
          onTap: () => AppRoute(
            title: '更新日志',
            page: KVTablePage('更新日志', locator<AppProvider>().changeLog),
          ).go(context),
        ),
        ListTile(
          leading: Icon(Icons.hardware, color: color),
          title: Text('贡献名单'),
          onTap: () => _showTesterNameList(),
        ),
        AboutListTile(
          icon: Icon(Icons.text_snippet, color: color),
          child: Text('开源证书'),
          applicationName: appName,
          applicationVersion: version,
          applicationIcon: Image.asset(
            custedIconPath,
            width: 64.0,
            height: 64.0,
          ),
          aboutBoxChildren: <Widget>[
            Text('\nMade with ❤️ by Toast Studio.\nAll rights reserved.')
          ],
        ),
      ],
    );
  }

  void _showTesterNameList() {
    String nameList = locator<AppProvider>().testerNameList;
    if (nameList.startsWith('close')) {
      showSnackBar(context, '暂时关闭');
      return;
    }
    showRoundDialog(
      context, 
      '感谢以下贡献者', 
      ListView(
        children: [
          Text(nameList)
        ],
      ), 
      [
        TextButton(
          onPressed: () => openUrl('https://jq.qq.com/?_wv=1027&k=TLrWZjtp'), 
          child: Text('加入用户群')
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('关闭')
        )
      ]
    );
  }

  Widget _buildLoginEntries(BuildContext context, bool isLoggedIn, Color color) {
    return Column(
      children: [
        _buildLoginTile(context, isLoggedIn, color),
        if (isLoggedIn) ListTile(
          leading: Icon(Icons.logout, color: color),
          title: Text('退出登录'),
          onTap: () async {
            await locator<PersistCookieJar>().deleteAll();
            await widget.user.logout();
          },
        ) 
      ],
    );
  }

  Widget _buildLoginTile(BuildContext context, bool isLoggedIn, Color color) {
    if (isLoggedIn) {
      return ListTile(
          leading: Icon(Icons.login, color: color),
          title: Text('重新登录'),
          onTap: () async {
            await WebviewLogin.begin(context, back2PrePage: true);
          },
        );
    } else if (showRealUI) {
      return ListTile(
          leading: Icon(Icons.web, color: color),
          title: Text('统一登录'),
          onTap: () async {
            await WebviewLogin.begin(context, back2PrePage: true);
          },
        );
    }
    return ListTile(
          leading: Icon(Icons.web, color: color),
          title: Text('传统登录'),
          onTap: () {
            AppRoute(page: LoginPageLegacy()).go(context);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = widget.user.loggedIn;
    final color = resolveWithBackground(context);

    return Drawer(
        child: ListView(
            padding: EdgeInsets.only(),
            children: <Widget>[
              _buildUserHeader(isLoggedIn),
              _buildUserEntries(context, isLoggedIn, color),
              Divider(),
              _buildLoginEntries(context, isLoggedIn, color)
            ]
        )
    );
  }
}