import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

class LoginPageLegacy extends StatefulWidget {
  @override
  _LoginPageLegacyState createState() => _LoginPageLegacyState();
}

class _LoginPageLegacyState extends State<LoginPageLegacy> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  bool isBusy = false;

  @override
  void initState() {
    loadUserLoginInfo();
    super.initState();
  }

  void loadUserLoginInfo() async {
    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();
    final password = userData.password.fetch();
    if (username != null || password != null) {
      usernameController.text = username;
      passwordController.text = password;
    }
  }

  Future<void> tryLogin() async {
    if (isBusy) return;

    setState(() => isBusy = true);

    final userData = await locator.getAsync<UserDataStore>();
    final mysso = locator<MyssoService>();
    final snake = locator<SnakebarProvider>();
    final user = locator<UserProvider>();

    userData.username.put(usernameController.text);
    userData.password.put(passwordController.text);
    final login = await mysso.login(force: true);

    if (login.ok) {
      user.login();
      snake.info('登录成功');
      Navigator.pop(context);
    } else {
      snake.warning('登录失败[${login.data}]');
      setState(() => isBusy = false);
    }
  }

  Future<void> forceLogin() async {
    final userData = await locator.getAsync<UserDataStore>();
    final snake = locator<SnakebarProvider>();
    final user = locator<UserProvider>();

    userData.username.put(usernameController.text);
    userData.password.put(passwordController.text);

    user.login();
    snake.info('#强制登录');
    Navigator.pop(context);
  }

  void focusOnPasswordField() {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: ImageRes.bgAbstractDark,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: _buildLoginForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final textFieldBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(
        color: Color(0x77FFFFFF),
        style: BorderStyle.solid,
        width: 1.0,
      ),
    );

    return ListView(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        CupertinoButton(
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.all(0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.arrow_back_ios, color: CupertinoColors.white),
          ),
        ),
        SizedBox(height: 50),
        _title(),
        SizedBox(height: 90),
        CupertinoTextField(
          controller: usernameController,
          placeholder: '一卡通号',
          keyboardType: TextInputType.number,
          placeholderStyle: TextStyle(color: Color(0x55FFFFFF)),
          style: TextStyle(color: CupertinoColors.white),
          decoration: textFieldBorderDecoration,
          onSubmitted: (_) => focusOnPasswordField(),
        ),
        SizedBox(height: 15),
        CupertinoTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          placeholder: '统一认证密码',
          placeholderStyle: TextStyle(color: Color(0x55FFFFFF)),
          style: TextStyle(color: CupertinoColors.white),
          obscureText: true,
          decoration: textFieldBorderDecoration,
          onSubmitted: (_) => tryLogin(),
        ),
        SizedBox(height: 90),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '登录',
              style: TextStyle(color: CupertinoColors.white, fontSize: 30),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 80,
                maxHeight: 80,
              ),
              child: GestureDetector(
                onLongPress: forceLogin,
                child: CupertinoButton(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: isBusy
                        ? CupertinoActivityIndicator()
                        : Icon(Icons.arrow_forward),
                  ),
                  color: CupertinoColors.activeBlue,
                  onPressed: tryLogin,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '欢迎使用',
          style: TextStyle(
            fontSize: 60,
            color: CupertinoColors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Custed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
            fontSize: 60,
          ),
        )
      ],
    );
  }
}
