import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:flutter/cupertino.dart';

class NavTabToggle extends StatelessWidget {
  NavTabToggle({this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return NavBarMoreBtn(
      onTap: onTap,
      alignment: Alignment.centerLeft,
      icon: const IconData(
        0xf394,
        fontFamily: 'CupertinoIcons',
        fontPackage: 'cupertino_icons',
      ),
    );
  }
}
