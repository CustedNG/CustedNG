import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavTabToggle extends StatelessWidget {
  NavTabToggle({this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      alignment: Alignment.centerLeft,
      icon: Icon(Icons.menu),
    );
  }
}
