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
    final changeLog = Provider.of<AppProvider>(context).changeLog;
    if (notification == null && changeLog == null) return Container();
    
    return GestureDetector(
      onTap: () => showRoundDialog(
        context, 
        '更新日志', 
        _buildChangeLogDialog(changeLog), 
        [_buildCloseButton(context)]
      ),
      child: HomeCard(
        title: Text('通知' , style: TextStyle(fontWeight: FontWeight.bold)),
        content: _buildContent(context, notification, changeLog),
        trailing: true,
      ),
    );
  }

  Widget _buildChangeLogDialog(Map changeLog) {
    final child = <Widget>[];
    for (var item in changeLog.entries) {
      child.add(Text(item.key, style: TextStyle(fontWeight: FontWeight.bold)));
      child.add(Text(item.value));
      child.add(SizedBox(height: 17));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: child,
      ),
    );
  }

  Widget _buildContent(context, notification, Map changeLog) {
    final style = TextStyle(
      fontSize: 13
    );
    final noti = Text(_buildNotification(context, notification), style: style);
    if (changeLog == null) {
      return noti;
    }
    final log = _buildChangeLog(changeLog);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        noti,
        SizedBox(height: 7),
        Text(log, style: style)
      ],
    );
  }

  String _buildNotification(context, String notification) {
    String content;
    if (notification.startsWith('!')) {
      showRoundDialog(
        context, 
        '重要提示', 
        Text(notification.substring(1)), 
        [_buildCloseButton(context)]
      );
      content = notification.substring(1);
    } else {
      content = notification ?? '<版本号 TechnicalPreview#${BuildData.build}>';
    }
    return content;
  }

  String _buildChangeLog(Map<String, String> changeLog) {
    num newest = 0;
    changeLog.keys.forEach((ele) {if (ele > newest) newest = num.parse(ele);});
    if (newest > BuildData.build) {
      return '最新版本：$newest，查看更新日志';
    }
    return null;
  }

  Widget _buildCloseButton(context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(), 
      child: Text('关闭')
    );
  }
}
