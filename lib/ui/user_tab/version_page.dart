import 'package:custed2/constants.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/ui/pages/intro_page.dart';
import 'package:custed2/ui/pages/issue_page.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final settingTextStyle = TextStyle(
        color: isDark(context)
            ? Colors.white
            : Colors.black
    );

    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: NavbarText('关于')
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Hero(
                tag: '123123',
                transitionOnUserGestures: true,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: DarkModeFilter(
                      child: Image.asset(
                          custedIconPath,
                          height: 50,
                          width: 50
                      ),
                    )
                )
            ),
            SizedBox(height: 10),
            Text(appName),
            SizedBox(height: 20),
            SettingItem(
              title: '下载地址',
              titleStyle: settingTextStyle,
              onTap: () => AppRoute(
                page: WebviewBrowser(custedAppUrl),
              ).go(context),
            ),
            SettingItem(
              title: '开源地址',
              titleStyle: settingTextStyle,
              onTap: () => AppRoute(
                page: WebviewBrowser(custedGithubUrl),
              ).go(context),
            ),
            SettingItem(
              title: '用户协议',
              titleStyle: settingTextStyle,
              onTap: () => AppRoute(
                page: WebviewBrowser(custedServiceAgreementUrl),
              ).go(context),
            ),
            SettingItem(
              title: '我要反馈',
              titleStyle: settingTextStyle,
              onTap: () => AppRoute(
                page: IssuePage(),
              ).go(context),
            ),
            SettingItem(
              title: '查看新版指引',
              titleStyle: settingTextStyle,
              onTap: () => AppRoute(
                  page: IntroScreen()
              ).go(context),
            )
          ],
        ),
      ),
    );
  }

}