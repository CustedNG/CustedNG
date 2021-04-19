import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notification = Provider.of<AppProvider>(context).notification;
    if (notification == null) return HomeCard.loading();
    
    return HomeCard(
      title: Text('通知' , style: TextStyle(fontWeight: FontWeight.bold)),
      content: _buildContent(context, notification)
    );
  }

  Widget _buildContent(context, notification) {
    final style = TextStyle(
      fontSize: 13
    );

    final noti = _buildNotification(context, notification);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' ' * 7 + noti[0], style: style),
        if (noti.length != 1) Container(
          alignment: Alignment.bottomRight,
          child: Text(
            noti[1], 
            style: style, 
            textAlign: TextAlign.right
          ),
        )
      ],
    );
  }

  List<String> _buildNotification(context, String notification) {
    if (notification.startsWith('!')) {
      showRoundDialog(
        context, 
        '重要提示', 
        Text(notification.substring(1)), 
        [_buildCloseButton(context)]
      );
      return notification.substring(1).split('发布于：');
    }
    return notification.split('发布于：') 
            ?? ['<版本号 TechnicalPreview#${BuildData.build}>'];
  }

  Widget _buildCloseButton(context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(), 
      child: Text('关闭')
    );
  }
}
