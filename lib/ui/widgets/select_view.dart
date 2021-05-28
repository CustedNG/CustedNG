import 'package:custed2/core/utils.dart';
import 'package:flutter/material.dart';

SelectView(IconData icon, String text, String id, BuildContext context) {
  return PopupMenuItem<String>(
    value: id,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          icon, 
          color: resolveWithBackground(context)
        ),
        SizedBox(width: 10.0),
        Text(text),
      ],
    )
  );
}

SelectViewText<T>(String text, T id) {
  return PopupMenuItem<T>(
    value: id,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(text),
      ],
    )
  );
}