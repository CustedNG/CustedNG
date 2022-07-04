import 'package:custed2/config/routes.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/campus_wifi_service.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/home_tab/home_entry.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:external_app_launcher2/external_app_launcher2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

class HomeEntries extends StatefulWidget {
  @override
  _HomeEntriesState createState() => _HomeEntriesState();
}

class _HomeEntriesState extends State<HomeEntries> {
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

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 14);

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
              name: Text('空教室', style: style),
              icon: Image(image: ImageRes.ecardIcon),
              action: () => emptyRoomPage.go(context)),
          HomeEntry(
            name: Text('体测成绩', style: style),
            icon: Image(image: ImageRes.runningReportIcon),
            // action: () => runScript('sport_grade.cl', context),
            action: () => ticeWebPage.go(context),
          ),
          HomeEntry(
            name: Shimmer.fromColors(
                child: Text('长理指北',
                    style: style.copyWith(fontWeight: FontWeight.bold)),
                baseColor:
                    DynamicColor(Colors.black, Colors.white).resolve(context),
                highlightColor: Colors.redAccent),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => ecardWebPage.go(context),
            action: () => custWikiPage.go(context),
          ),
        ]),
        TableRow(children: [
          HomeEntry(
            name: Text('题库', style: style),
            icon: Image(image: ImageRes.tikuIcon),
            action: () async {
              final result =
                  await ExternalAppLauncher2.openApp('toasttiku://home');
              if (!result) {
                tikuPage.go(context);
              }
            },
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
    showRoundDialog(context, '连接校园网', _buildTextInputField(context), [
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text('关闭')),
      TextButton(onPressed: () => tryLogin(context), child: Text('连接'))
    ]);
    loadUserLoginInfo();
  }

  InputDecoration _buildDecoration(String label, {TextStyle textStyle}) {
    return InputDecoration(labelText: label, labelStyle: textStyle);
  }

  Widget _buildTextInputField(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: usernameController,
          keyboardType: TextInputType.number,
          decoration: _buildDecoration('校园网账户'),
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(passwordFocusNode),
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
            Text('保存登录信息'),
            buildSwitch(context, setting.saveWiFiPassword)
          ],
        )
      ],
    );
  }

  void loadUserLoginInfo() async {
    final info = (userData.wifiCampusInfo.fetch() ?? '').split(' | ');
    if (info.length != 2) return;
    final username = info[0];
    final password = info[1];
    if (username != null || password != null) {
      usernameController.text = username;
      passwordController.text = password;
    }
  }

  Future<void> tryLogin(BuildContext ctx) async {
    String user = usernameController.text;
    String pwd = passwordController.text;

    try {
      final suc = await CampusWiFiService().login(user, pwd);

      if (suc) {
        showSnackBar(context, '校园网登录成功');
      } else {
        showSnackBar(ctx, '校园网认证失败');
      }
    } catch (e) {
      rethrow;
    } finally {
      Navigator.pop(ctx);
      if (setting.saveWiFiPassword.fetch()) {
        userData.wifiCampusInfo.put('$user | $pwd');
      }
    }
  }
}
