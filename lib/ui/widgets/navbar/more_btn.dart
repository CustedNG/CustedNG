import 'package:flutter/cupertino.dart';

class NavBarMoreBtn extends StatelessWidget {
  NavBarMoreBtn({
    this.onTap,
    this.icon = CupertinoIcons.ellipsis,
    this.alignment = Alignment.centerRight,
  });

  final Function onTap;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: 100,
      child: CupertinoButton(
        onPressed: onTap,
        minSize: 0,
        padding: EdgeInsets.zero,
        child: Icon(
          icon,
          size: 32,
          color: CupertinoColors.white
        ),
      ),
    );
  }
}
