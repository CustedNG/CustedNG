import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Snakebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snakebarData = Provider.of<SnakebarProvider>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: snakebarData.isActive ? 25 : 0,
      color: snakebarData.bgColor,
      child: Center(
        child: snakebarData.widget,
      ),
    );
  }
}
