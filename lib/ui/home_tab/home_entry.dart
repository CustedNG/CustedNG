import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';

class HomeEntry extends StatelessWidget {
  HomeEntry({this.name, this.icon, this.action, this.longPressAction});

  final Widget name;
  final Widget icon;
  final void Function() action;
  final void Function() longPressAction;

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      onLongPress: longPressAction,
      onPressed: action ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          SizedBox(height: 30, child: DarkModeFilter(child: icon)),
          SizedBox(height: 10),
          name,
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
