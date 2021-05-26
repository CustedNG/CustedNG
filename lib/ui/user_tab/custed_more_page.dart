import 'package:custed2/constants.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/ui/pages/issue_page.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustedMorePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final widgets = [
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
        title: '开源地址',
        onTap: () => AppRoute(
          page: WebviewBrowser(custedGithubUrl),
        ).go(context),
      ),
      SettingItem(
        title: '用户协议',
        onTap: () => AppRoute(
          page: WebviewBrowser(custedServiceAgreementUrl),
        ).go(context),
      ),
      SettingItem(
        title: '我要反馈',
        onTap: () => AppRoute(
          page: IssuePage(),
        ).go(context),
      ),
    ];

    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: NavbarText('关于')
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 3), 
                    child: widgets[index]
                  ),
                ),
              ),
            );
          },
        ),
      )
    );
  }

}