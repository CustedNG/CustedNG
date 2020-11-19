import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content){
  Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      )
  );
}

void showCatchSnackBar(BuildContext context, Function func, String message){
  Future.sync(func).catchError((e) => showSnackBar(context, message ?? '$e'));
}

void showRoundDialog(BuildContext context, String title, Widget child, List<Widget> actions){
  showDialog(
      context: context,
      builder: (ctx) {
        return CardDialog(
          title: Text(title),
          content: child,
          actions: actions,
        );
      }
  );
}