import 'package:flutter/cupertino.dart';

class NavBarTitle extends StatelessWidget {
  NavBarTitle({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );

    return Container(
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: style,
        child: child,
      ),
    );
  }
}
