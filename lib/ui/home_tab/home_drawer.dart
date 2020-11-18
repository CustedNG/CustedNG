import 'package:custed2/config/routes.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget{
  final version;
  final myTheme;
  final UserProvider user;

  const HomeDrawer({
    Key key, this.version, this.myTheme, this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = user.loggedIn;

    return Drawer(
        child: ListView(
            padding: EdgeInsets.only(),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName:
                Text(isLoggedIn ? ' ' + user.profile.displayName : '请登录'),
                accountEmail:
                Text(isLoggedIn ? user.profile.department : '(´･ω･`)'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/icon/custed_lite.png'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('四六级照片'),
                onTap: () {
                  locator<CetAvatarProvider>().getAvatar();
                  cetAvatarPage.go(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cloud),
                title: Text('校园网盘'),
                onTap: () {
                  locator<NetdiskProvider>().getQuota();
                  netdiskPage.go(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('版本信息'),
                onTap: () => aboutPage.go(context),
              ),
              AboutListTile(
                icon: Icon(Icons.text_snippet),
                child: Text('开源证书'),
                applicationName: "CustedNG",
                applicationVersion: version,
                applicationIcon: Image.asset(
                  'assets/icon/custed_lite.png',
                  width: 64.0,
                  height: 64.0,
                ),
                aboutBoxChildren: <Widget>[
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            style: myTheme.textTheme.bodyText1,
                            text: '\nBy Toast Studio\n\n开源地址：'),
                        TextSpan(
                            style: myTheme.textTheme.bodyText1
                                .copyWith(color: myTheme.accentColor),
                            text: 'https://github.com/CustedNG/CustedNG')
                      ])
                  )
                ],
              ),
              isLoggedIn ? ListTile(
                leading: Icon(Icons.login),
                title: Text('重新登录'),
                onTap: () => _login(context),
              ) : Container(),
              isLoggedIn ? ListTile(
                leading: Icon(Icons.logout),
                title: Text('退出登录'),
                onTap: () => _logout(context),
              ) : Container(),
            ]
        )
    );
  }


  void _login(BuildContext context) {
    loginPage.popup(context);
  }

  void _logout(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.logout();
  }
}