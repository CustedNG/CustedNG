import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  BackIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_back_sharp,
      size: 25,
      color: Colors.white,
    );
  }
}
