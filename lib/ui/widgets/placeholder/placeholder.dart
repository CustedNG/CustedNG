import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  PlaceholderWidget({
    this.text,
    this.isActive = false,
    this.light = false,
  });

  final String text;
  final bool isActive;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: light ? FontWeight.normal : FontWeight.bold,
    );

    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isActive) Center(child: CircularProgressIndicator()),
            if (isActive) SizedBox(height: 10),
            Text(
              text ?? defaultText,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  //怕写施工中，ios审核会以完成度不够拒绝
  String get defaultText => isActive ? '加载中...' : '暂无数据';//'施工中...';
}
