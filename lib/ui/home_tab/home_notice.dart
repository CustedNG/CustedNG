import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notification = Provider.of<AppProvider>(context).notification;
    if (notification == null) return Container();
    if (notification.startsWith('!')) {
      showRoundDialog(
        context, 
        '重要提示', 
        Text(notification.substring(1)), 
        [TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text('好')
        )]
      );
    }
    return HomeCard(
      title: Text('通知'),
      content: Text(
          notification.substring(1)
              ?? '<版本号 TechnicalPreview#${BuildData.build}>'),
    );
  }
}
