import 'package:flutter/material.dart';

SelectView(IconData icon, String text, String id) {
  return PopupMenuItem<String>(
    value: id,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(icon, color: Colors.blue),
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