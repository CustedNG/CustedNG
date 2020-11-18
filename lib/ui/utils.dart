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