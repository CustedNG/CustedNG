import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/snakebar.dart';
import 'package:flutter/material.dart';

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
    final user = locator<UserProvider>();

    userData.username.put(usernameController.text);
    userData.password.put(passwordController.text);

    try {
      final login =
          await mysso.login(force: true).timeout(Duration(minutes: 1));
      if (login.ok) {
        user.login();
        showSnackBar(context, '登录成功');
        Navigator.pop(context);
      } else {
        showSnackBar(context, '登录失败[${login.data}]');
      }
    } catch (e) {
      showSnackBar(context, '登录失败[认证系统超时]');
      rethrow;
    } finally {
      setState(() => isBusy = false);
    }
  }

  Future<void> forceLogin() async {
    final userData = await locator.getAsync<UserDataStore>();
    final user = locator<UserProvider>();

    userData.username.put(usernameController.text);
    userData.password.put(passwordController.text);

    user.login();
    showSnackBar(context, '#强制登陆');
    Navigator.pop(context);
  }

  void focusOnPasswordField() {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: Scaffold(
              body: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ImageRes.bgAbstractDark,
                  ),
                ),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: _buildLoginForm(context)
                ),
              ),
            )
        ),
        Snakebar()
      ],
    );
  }

  InputDecoration _buildDecoration(String label, TextStyle textStyle){
    return InputDecoration(
      labelText: label,
      labelStyle: textStyle,
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.cyan
        )
      )
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.all(0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
              SizedBox(height: 47),
              _title(),
              SizedBox(height: 77),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: _buildDecoration('一卡通号', TextStyle(color: Color(0x55FFFFFF))),
                onSubmitted: (_) => focusOnPasswordField(),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: _buildDecoration('统一认证密码', TextStyle(color: Color(0x55FFFFFF))),
                onSubmitted: (_) => tryLogin(),
              ),
              SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '登录',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 80,
                      maxHeight: 80,
                    ),
                    child: GestureDetector(
                      onLongPress: forceLogin,
                      onTap: tryLogin,
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: Center(
                          child: isBusy
                              ? CircularProgressIndicator()
                              : Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        )
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
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Custed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 60,
          ),
        )
      ],
    );
  }
}
