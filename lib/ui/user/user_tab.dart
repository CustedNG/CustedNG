import 'package:custed2/config/route.dart';
import 'package:custed2/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoButton(
        child: Text('点我登录'),
        color: AppTheme.of(context).btnPrimaryColor,
        onPressed: () {
          loginPage.go(context);
        },
      ),
    );
  }
}
