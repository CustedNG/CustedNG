import 'package:flutter/material.dart';

class CardDialog extends StatelessWidget {

  CardDialog({
    this.title,
    this.child,
    this.actions,
  });

  final Widget child;
  final List<Widget> actions;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(17, 3, 17, 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: title,
      content: child,
      actions: actions,
    );
  }
}
