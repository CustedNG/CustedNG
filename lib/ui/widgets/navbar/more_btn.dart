import 'package:flutter/cupertino.dart';

class NavBarMoreBtn extends StatelessWidget {
  NavBarMoreBtn({
    this.onTap,
    this.icon = CupertinoIcons.ellipsis,
  });

  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: 100,
      child: CupertinoButton(
        onPressed: onTap,
        minSize: 0,
        padding: EdgeInsets.zero,
        child: Icon(
          icon,
          size: 32,
        ),
      ),
    );
  }
}
