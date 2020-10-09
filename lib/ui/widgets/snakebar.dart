import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Snakebar extends StatefulWidget {
  @override
  _SnakebarState createState() => _SnakebarState();
}

class _SnakebarState extends State<Snakebar> {
  @override
  Widget build(BuildContext context) {
    final hasHomeBar = MediaQuery.of(context).padding.bottom != 0;
    final snakeBarData = Provider.of<SnakebarProvider>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: snakeBarData.isActive ? (hasHomeBar ? 16 : 0) + 25.0 : 0,
      color: snakeBarData.content.bgColor,
      child: Align(
        alignment: hasHomeBar ? Alignment(0.0, -0.8) : Alignment.center,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: snakeBarData.content.widget,
        ),
      ),
    );
  }
}
