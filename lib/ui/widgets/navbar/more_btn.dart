import 'package:flutter/material.dart';

class NavBarMoreBtn extends StatelessWidget {
  NavBarMoreBtn({
    this.onTap,
    this.icon = Icons.more_horiz,
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
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 32,
        ),
      ),
    );
  }
}
