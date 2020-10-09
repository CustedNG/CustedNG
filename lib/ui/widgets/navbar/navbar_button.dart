import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  NavBarButton({this.alignment = Alignment.center, this.child, this.onPressed});

  NavBarButton.leading({this.child, this.onPressed})
      : alignment = Alignment.centerLeft;

  NavBarButton.trailing({this.child, this.onPressed})
      : alignment = Alignment.centerRight;

  NavBarButton.close({this.onPressed})
      : alignment = Alignment.centerLeft,
        child =
            Icon(Icons.clear, color: Colors.white, size: 22);

  final Widget child;
  final Function onPressed;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      child: FlatButton(
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
