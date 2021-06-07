import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/widgets/url_text.dart';
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
    final style = Theme.of(context).textTheme.bodyText1.copyWith(
      fontSize: 13
    );

    final noti = _buildNotification(context, notification);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UrlText(' ' * 7 + noti.content, style: style),
        if (noti.date != null) Container(
          alignment: Alignment.bottomRight,
          child: Text(
            noti.date, 
            style: style, 
            textAlign: TextAlign.right
          ),
        )
      ],
    );
  }

  Notification _buildNotification(context, String notification) {
    if (notification.startsWith('!')) {
      showRoundDialog(
        context, 
        '重要提示', 
        Text(notification.substring(1)), 
        [_buildCloseButton(context)]
      );
      final data = notification.substring(1).split('发布于：');
      return Notification(data[1], data[0]);
    }
    final data = notification.split('发布于：');
    return Notification(data[1], data[0] ?? ['<版本号 TechnicalPreview#${BuildData.build}>']
    );
  }

  Widget _buildCloseButton(context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(), 
      child: Text('关闭')
    );
  }
}

class Notification {
  final String date;
  final String content;

  Notification(this.date, this.content);
}
