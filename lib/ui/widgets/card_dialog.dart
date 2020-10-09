import 'package:flutter/material.dart';

class CardDialog extends StatelessWidget {

  CardDialog({
    this.child,
    this.actions,
    this.width,
  });

  final Widget child;
  final List<Widget> actions;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: AlertDialog(
          content: child,
          actions: actions,
        ),
      ),
    );
  }
}
