import 'package:flutter/cupertino.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget();

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  bool showCurrent = false;

  @override
  Widget build(BuildContext context) {
    final baseFont = TextStyle(
      fontSize: 12,
    );

    final textTop = showCurrent
        ? '当前'
        : '${'长春'} ${'晴'}';

    final textBottom = showCurrent
        ? '${'-20'}℃'
        : '${'-20'}~${'-8'}';

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          textTop,
          style: baseFont.copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          textBottom,
          style: baseFont.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: content,
      onPressed: () {
        setState(() {
          showCurrent = !showCurrent;
        });
      },
    );
  }
}
