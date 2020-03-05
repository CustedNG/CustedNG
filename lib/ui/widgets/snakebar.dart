import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Snakebar extends StatefulWidget {
  @override
  _SnakebarState createState() => _SnakebarState();
}

class _SnakebarState extends State<Snakebar> {
  @override
  Widget build(BuildContext context) {
    final btmPadding = MediaQuery.of(context).padding.bottom;
    final snakebarData = Provider.of<SnakebarProvider>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: snakebarData.isActive ? (btmPadding == 0 ? 0.0 : 16.0) + 25.0 : 0,
      color: snakebarData.content.bgColor,
      child: Align(
        alignment: Alignment(0.0, -0.8),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: snakebarData.content.widget,
        ),
      ),
    );
  }
}
