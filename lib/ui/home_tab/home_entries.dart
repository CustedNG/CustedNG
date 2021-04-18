import 'package:custed2/config/routes.dart';
import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/campus_wifi_service.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/home_tab/home_entry.dart';
import 'package:custed2/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class HomeEntries extends StatefulWidget {
  @override
  _HomeEntriesState createState() => _HomeEntriesState();
}

class _HomeEntriesState extends State<HomeEntries> {
  String tikuUrl = 'https://tiku.lacus.site';
  bool isBusy = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  UserDataStore userData;
  SettingStore setting;

  Future<void> init() async {
    await GetIt.instance.allReady();
    WidgetsFlutterBinding.ensureInitialized();
    userData = locator<UserDataStore>();
    setting = locator<SettingStore>();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> loadUserName() async {
    final user = Provider.of<UserProvider>(context);

    if(!user.loggedIn) return;

    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();
    setState(() {
      tikuUrl = 'https://tiku.lacus.site/?cid=$username';
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 13);
    loadUserName();

    return HomeCard(
      padding: 5,
      content: Table(children: [
        TableRow(children: [
          HomeEntry(
            name: Text('我的教务', style: style),
            icon: Image(image: ImageRes.manageIcon),
            action: () => jwWebPage.go(context),
          ),
          HomeEntry(
            name: Text('校内导航', style: style),
            icon: Image(image: ImageRes.ecardIcon),
            // action: () => iecardWebPage.go(context),
            // action: () => openIecard(context),
            action: () => navPage.go(context)
          ),
          HomeEntry(
            name: Text('体测成绩', style: style),
            icon: Image(image: ImageRes.runningReportIcon),
            // action: () => runScript('sport_grade.cl', context),
            action: () => ticeWebPage.go(context),
          ),
          HomeEntry(
            name: Text('充网费', style: style),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => ecardWebPage.go(context),
            action: () => gotoWechat.go(context),
          ),
        ]),
        TableRow(children: [
          HomeEntry(
            name: Text('题库', style: style),
            icon: Image(image: ImageRes.tikuIcon),
            action: () => tiku2WebPage.go(context),
          ),
          HomeEntry(
            name: Text('地图', style: style),
            icon: Image(image: ImageRes.mapIcon),
            action: () => mapPage.go(context),
          ),
          HomeEntry(
            name: Text('校园网', style: style),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => runScript('network_manage.cl', context),
            action: () => selfWebPage.go(context),
          ),
          HomeEntry(
            name: Text('快速联网', style: style),
            icon: Image(image: ImageRes.wifiIcon),
            action: () => _showConnectWiFiDialog(),
          ),
        ])
      ]),
    );
  }

  void _showConnectWiFiDialog() {
    showRoundDialog(
      context, 
      '连接校园网', 
      _buildTextInputField(context), 
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('关闭')
        ),
        isBusy ? CircularNotchedRectangle() : TextButton(
          onPressed: () => tryLogin(context), 
          child: Text('连接')
        )
      ]
    );
    loadUserLoginInfo();
  }

  InputDecoration _buildDecoration(String label, {TextStyle textStyle}){
    return InputDecoration(
      labelText: label,
      labelStyle: textStyle
    );
  }

  Widget _buildTextInputField(BuildContext ctx){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: usernameController,
          keyboardType: TextInputType.number,
          decoration: _buildDecoration('校园网账户'),
          onSubmitted: (_) => FocusScope.of(context).requestFocus(passwordFocusNode),
        ),
        SizedBox(height: 15),
        TextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: true,
          decoration: _buildDecoration('校园网密码'),
          onSubmitted: (_) => tryLogin(ctx),
        ),
        Row(
          children: [
            Text('保存校园网密码'),
            _buildSwitch(context, setting.saveWiFiPassword)
          ],
        )
      ],
    );
  }

  Widget _buildSwitch(BuildContext context, StoreProperty<bool> prop, {Function func}) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, value, widget) {
        return Switch(
            value: value, onChanged: (value) {
              if (func != null) func();
              return prop.put(value);
            }
        );
      },
    );
  }

  void loadUserLoginInfo() async {
    final username = userData.username.fetch();
    final password = userData.wifiPassword.fetch();
    if (username != null || password != null) {
      usernameController.text = username;
      passwordController.text = password;
    }
  }

  Future<void> tryLogin(BuildContext ctx) async {
    if (isBusy) return;

    setState(() => isBusy = true);

    try {
      String user = usernameController.text;
      String pwd = passwordController.text;

      final suc = await CampusWiFiService().login(user, pwd).timeout(
        Duration(seconds: 10)
      );

      if (suc) {
        if (setting.saveWiFiPassword.fetch()) {
          userData.wifiPassword.put(pwd);
        }
        Navigator.pop(ctx);
        showSnackBar(context, '校园网登录成功');
      } else {
        showSnackBar(ctx, '校园网认证失败');
      }
    } catch (e) {
      print('catch exception during connect to campus wifi');
    } finally {
      setState(() => isBusy = false);
    }
  }
}
