import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class DarkModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
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
            CSSelectionItem<int>(text: '自动', value: 0),
            CSSelectionItem<int>(text: '开', value: 1),
            CSSelectionItem<int>(text: '关', value: 2),
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
