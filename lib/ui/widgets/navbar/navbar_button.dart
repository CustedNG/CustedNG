import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class NavBarButton extends StatelessWidget {
  NavBarButton({this.alignment = Alignment.center, this.child, this.onPressed});

  NavBarButton.leading({this.child, this.onPressed})
      : alignment = Alignment.centerLeft;

  NavBarButton.trailing({this.child, this.onPressed})
      : alignment = Alignment.centerRight;

  NavBarButton.close({this.onPressed})
      : alignment = Alignment.centerLeft,
        child =
            Icon(material.Icons.clear, color: CupertinoColors.white, size: 22);

  final Widget child;
  final Function onPressed;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      child: CupertinoButton(
        child: Container(
          child: this.child,
          alignment: alignment,
        ),
        padding: EdgeInsets.all(0),
        onPressed: this.onPressed,
      ),
    );
  }
}
