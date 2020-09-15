import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DarkModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: NavBar.material(
          context: context,
          leading: GestureDetector(
              child: BackIcon(), onTap: () => Navigator.pop(context)),
          middle: NavbarText('黑暗模式')),
      body: _buildRoot(context),
      backgroundColor: theme.backgroundColor,
    );
  }

  Widget _buildRoot(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final setting = locator<SettingStore>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('自动'),
            Radio(
                value: 0,
                groupValue: setting.darkMode.fetch(),
                onChanged: _onSelection),
            Text('开'),
            Radio(
                value: 1,
                groupValue: setting.darkMode.fetch(),
                onChanged: _onSelection),
            Text('关'),
            Radio(
                value: 2,
                groupValue: setting.darkMode.fetch(),
                onChanged: _onSelection)
          ],
        ),
        SizedBox(height: 10.0),
        Center(
          child: Text('自动模式仅在 iOS 13+ 与 Android 10+ 系统下有效'),
        )
      ],
    );
  }

  void _onSelection(int index) {
    print(index.toString());
    final setting = locator<SettingStore>();
    setting.darkMode.put(index);
  }
}
