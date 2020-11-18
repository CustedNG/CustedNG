import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      title: Text('通知'),
      content: Text(
          Provider.of<AppProvider>(context).notification
              ?? '<版本号 TechnicalPreview#${BuildData.build}>'),
    );
  }
}
