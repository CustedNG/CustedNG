import 'package:flutter/material.dart';

class NavBarTitle extends StatelessWidget {
  NavBarTitle({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );

    return Container(
      width: 70,
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: style,
        child: child,
      ),
    );
  }
}
