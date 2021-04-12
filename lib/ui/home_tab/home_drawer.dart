import 'package:custed2/config/routes.dart';
import 'package:custed2/constants.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
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
        ListTile(
          leading: Icon(Icons.info),
          title: Text('版本信息'),
          onTap: () => aboutPage.go(context),
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
          onTap: () => loginPage.go(context),
        ) : ListTile(
          leading: Icon(Icons.web),
          title: Text('统一登录'),
          onTap: () => loginPage.go(context),
        ),
        isLoggedIn ? ListTile(
          leading: Icon(Icons.logout),
          title: Text('退出登录'),
          onTap: () async => await user.logout(),
        ) : ListTile(
          leading: Icon(Icons.input),
          title: Text('传统登录'),
          onTap: () => loginPageLegacy.go(context),
        ),
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