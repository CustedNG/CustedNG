import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/material.dart';

class HomeNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = locator<SettingStore>();

    return HomeCard(
      title: Text('通知'),
      content: ValueListenableBuilder(
        valueListenable: settings.notification.listenable(),
        builder: (context, value, _) =>
            Text(value ?? '<版本号 TechnicalPreview#${BuildData.build}>'),
      ),
    );
  }
}
