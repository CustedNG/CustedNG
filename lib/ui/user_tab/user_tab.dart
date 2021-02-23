import 'package:custed2/config/routes.dart';
import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/user_tab/custed_header.dart';
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

class _UseTabState extends State<UserTab> with AutomaticKeepAliveClientMixin{
  final setting = locator<SettingStore>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<UserProvider>(context);

    if (user.isBusy) return PlaceholderWidget(isActive: true);
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
      child: Text(text, style: TextStyle(color: Colors.white)),
      onPressed: () => isLegacy
          ? loginPageLegacy.go(context)
          : loginPage.go(context),
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
    final theme = AppTheme.of(context);

    return Scaffold(
        backgroundColor: theme.homeBackgroundColor,
        appBar: NavBar.material(
          context: context,
          leading: Container(),
          middle: NavbarText('设置'),
        ),
        body: SingleChildScrollView(
          child: _buildSetting()
        ));
  }

  Widget _buildSetting(){
    final settingTextStyle = TextStyle(
      color: isDark(context)
          ? Colors.white
          : Colors.black
    );
    return Column(
      children: [
        CustedHeader(),
        SizedBox(height: 10.0),
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
          title: '启动时自动更新课表',
          titleStyle: settingTextStyle,
          isShowArrow: false,
          rightBtn: _buildSwitch(
              context, setting.autoUpdateSchedule),
        ),
        SettingItem(
          title: '持续自动更新天气',
          titleStyle: settingTextStyle,
          isShowArrow: false,
          rightBtn: _buildSwitch(
              context, setting.autoUpdateWeather),
        ),
        SettingItem(
          title: '黑暗模式',
          titleStyle: settingTextStyle,
          isShowArrow: false,
          rightBtn: _buildDarkModeRadio(),
        ),
        SizedBox(height: 40.0)
      ],
    );
  }

  Widget _buildDarkModeRadio(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('自动'),
        Radio(
            value: 0,
            groupValue: setting.darkMode.fetch(),
            onChanged: _onSelection
        ),
        Text('开'),
        Radio(
            value: 1,
            groupValue: setting.darkMode.fetch(),
            onChanged: _onSelection
        ),
        Text('关'),
        Radio(
            value: 2,
            groupValue: setting.darkMode.fetch(),
            onChanged: _onSelection
        )
      ],
    );
  }

  void _onSelection(int index) {
    if(index == 0)Scaffold.of(context).showSnackBar(SnackBar(content: Text('自动模式仅在Android 10+或iOS 13+有效')));
    print(index.toString());
    final setting = locator<SettingStore>();
    setting.darkMode.put(index);
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

  @override
  bool get wantKeepAlive => true;
}
