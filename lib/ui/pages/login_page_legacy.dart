import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/core/util/utils.dart';
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

  Future<void> tryLogin(BuildContext ctx) async {
    if (isBusy) return;

    setState(() => isBusy = true);

    final userData = await locator.getAsync<UserDataStore>();
    final mysso = locator<MyssoService>();
    final user = locator<UserProvider>();

    userData.username.put(usernameController.text);
    userData.password.put(passwordController.text);

    try {
      final login = await mysso.login(force: true);
      if (login.ok) {
        user.login();
        Navigator.pop(ctx);
      } else {
        showSnackBar(ctx, '登录失败[${login.data}]');
      }
    } catch (e) {
      showSnackBar(ctx, '登录失败[$e]');
      rethrow;
    } finally {
      setState(() => isBusy = false);
    }
  }

  Future<void> forceLogin(BuildContext ctx) async {
    final userData = await locator.getAsync<UserDataStore>();
    final user = locator<UserProvider>();

    userData.username.put(usernameController.text);
    userData.password.put(passwordController.text);

    await user.login(force: true);
    await CustedService().login2Backend("", "FakeUser", "");
    Navigator.of(context).pop(ctx);
  }

  void focusOnPasswordField() {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: ImageRes.bgAbstractDark,
          ),
        ),
        child: Builder(builder: (cc) => _buildLoginForm(cc)),
      ),
    );
  }

  InputDecoration _buildDecoration(String label, TextStyle textStyle) {
    return InputDecoration(
        labelText: label,
        labelStyle: textStyle,
        border: OutlineInputBorder(),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)));
  }

  Widget _buildTextInputField(BuildContext ctx) {
    return Column(
      children: [
        SizedBox(height: 77),
        TextField(
          controller: usernameController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration:
              _buildDecoration('一卡通号', TextStyle(color: Color(0x55FFFFFF))),
          onSubmitted: (_) => focusOnPasswordField(),
        ),
        SizedBox(height: 15),
        TextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          style: TextStyle(color: Colors.white),
          obscureText: true,
          decoration:
              _buildDecoration('统一认证密码', TextStyle(color: Color(0x55FFFFFF))),
          onSubmitted: (_) => forceLogin(ctx),
        ),
        SizedBox(height: 90),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Column(
      children: [
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
                onLongPress: () => forceLogin(context),
                onTap: () => forceLogin(context),
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
    );
  }

  Widget _buildHead() {
    return Column(
      children: [
        SizedBox(height: 20),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        SizedBox(height: 47),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext ctx) {
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHead(),
              _title(),
              _buildTextInputField(ctx),
              _buildFAB(ctx)
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
