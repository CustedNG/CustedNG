import 'package:flutter/material.dart';

class CardDialog extends StatelessWidget {

  CardDialog({
    this.title,
    this.content,
    this.actions,
  });

  final Widget content;
  final List<Widget> actions;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24, 17, 24, 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: title,
      content: content,
      actions: actions,
    );
  }
}
