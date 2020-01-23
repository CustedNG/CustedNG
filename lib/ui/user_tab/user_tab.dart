import 'package:custed2/config/route.dart';
import 'package:custed2/config/theme.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = locator<UserProvider>();

    if (user.isBusy) {
      return PlaceholderWidget(isActive: true);
    }

    final hasProfile = user.profile != null;
    return hasProfile
        ? _buildUserTab(context, user.profile)
        : _buildLoginButton(context);
  }

  Widget _buildLoginButton(BuildContext context) {
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

  Widget _buildUserTab(BuildContext context, UserProfile profile) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: DefaultTextStyle(
        style: TextStyle(fontFamily: 'Roboto'),
        child: CupertinoSettings(
          items: <Widget>[
            CSHeader('用户'),
            CSWidget(_buildUserInfo(context, profile)),
            CSControl('四六级照片', Icon(CupertinoIcons.right_chevron)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProfile profile) {
    return Text(profile.displayName);
  }
}
