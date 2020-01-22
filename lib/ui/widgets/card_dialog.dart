import 'package:flutter/cupertino.dart';

class CardDialog extends StatelessWidget {
  static const double _dialogWidth = 270.0;

  CardDialog({
    this.child,
    this.width = _dialogWidth,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: this.width,
        child: CupertinoPopupSurface(
          child: child,
        ),
      ),
    );
  }
}
