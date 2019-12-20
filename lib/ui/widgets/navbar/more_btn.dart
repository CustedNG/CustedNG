import 'package:flutter/cupertino.dart';

class NavBarMoreBtn extends StatelessWidget {
  NavBarMoreBtn({
    this.onTap,
  });

  final Function onTap;

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
          CupertinoIcons.ellipsis,
          size: 32,
        ),
      ),
    );
  }
}
