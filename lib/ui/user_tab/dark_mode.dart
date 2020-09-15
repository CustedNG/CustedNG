import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class DarkModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
          context: context,
          leading: GestureDetector(
              child: BackIcon(), onTap: () => Navigator.pop(context)),
          middle: NavbarText('黑暗模式')),
      child: _buildRoot(context),
      backgroundColor: Color(0xFFEEEEF3),
    );
  }

  Widget _buildRoot(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final setting = locator<SettingStore>();
    return CupertinoSettings(
      items: <Widget>[
        CSHeader('模式'),
        CSSelection<int>(
          items: <CSSelectionItem<int>>[
            CSSelectionItem<int>(text: '自动', value: DarkMode.auto),
            CSSelectionItem<int>(text: '开', value: DarkMode.on),
            CSSelectionItem<int>(text: '关', value: DarkMode.off),
          ],
          onSelected: _onSelection,
          currentSelection: setting.darkMode.fetch(),
        ),
        CSDescription(
          '自动模式仅在 iOS 13+ 与 Android 10+ 系统下有效',
        ),
      ],
    );
  }

  void _onSelection(int index) {
    print(index.toString());
    final setting = locator<SettingStore>();
    setting.darkMode.put(index);
  }
}
