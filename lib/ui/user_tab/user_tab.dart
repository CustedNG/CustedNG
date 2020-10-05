import 'package:custed2/config/routes.dart';
import 'package:custed2/core/store/presistent_store.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UseTabState();
}

class _UseTabState extends State<UserTab> with TickerProviderStateMixin{
  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  double _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.9,
      duration: Duration(milliseconds: 777),
    );
    _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic
    )..addListener(() { setState(() {});});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    if (user.isBusy) {
      return PlaceholderWidget(isActive: true);
    }

    return user.loggedIn ? _buildUserTab(context) : _buildLoginButton(context);
  }

  Widget loginBtn(String text, bool isLegacy){
    return MaterialButton(
      height: 47,
      minWidth: 177,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      color: isLegacy ? Colors.cyan : Colors.lightBlueAccent,
      child: Text(text),
      onPressed: () => isLegacy
          ? loginPageLegacy.go(context)
          : loginPage.popup(context),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          loginBtn('统一认证登录', false),
          SizedBox(height: 20),
          Text(
            '或',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          loginBtn('传统登录', true),
        ],
      ),
    );
  }

  Widget _buildUserTab(BuildContext context) {
    final setting = locator<SettingStore>();
    final darkModeStatus = ['自动', '开', '关'][setting.darkMode.fetch()];
    final settingTextStyle =
    TextStyle(color: isDark(context) ? Colors.white : Colors.black);
    final theme = AppTheme.of(context);
    _scale = 1 - _curvedAnimation.value;

    return Scaffold(
        backgroundColor: theme.homeBackgroundColor,
        appBar: NavBar.material(
          context: context,
          middle: NavbarText('设置'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: (){
                    _controller.forward();
                    Future.delayed(Duration(milliseconds: 300), () => _controller.reverse());
                  },
                  child: Transform.scale(
                    scale: _scale,
                    child:Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: false,
                      child: Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 10 / 3,
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
                                        child: Image.asset(
                                            'assets/icon/custed_lite.png',
                                            height: 50,
                                            width: 50
                                        ),
                                      )
                                  ),
                                  SizedBox(width: 40.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Custed NG',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Ver: Material 1.0.${BuildData.build}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      )
                                    ],
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  )
                )
              ),
              Column(
                children: [
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
                      _logInOutBtn(context, '重新登录', Colors.lightBlue, () =>
                          _login(context)),
                      SizedBox(width: 40.0),
                      _logInOutBtn(context, '退出登录', Colors.redAccent, () =>
                          _logout(context))
                    ],
                  ),
                  SizedBox(height: 40.0)
                ],
              )
            ],
          ),
        ));
  }

  Widget _logInOutBtn(BuildContext context, String btnName, Color color,
      GestureTapCallback onTap) {
    return Container(
      height: 35.0,
      child: Material(
        elevation: 10.0,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: MaterialButton(
            child: Text(btnName), textColor: Colors.white, onPressed: onTap),
      ),
    );
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
    loginPage.popup(context);
  }

  void _logout(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.logout();
  }
}
