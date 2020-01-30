import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

class BottomSheet extends StatelessWidget {
  BottomSheet({this.child, this.sheet});

  final Widget child;
  final Widget sheet;

  Color get bgColor => Color(0xFFF9F9F9);
  final headerHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    return ExpandableBottomSheet(
      // background: Column(
      //   children: <Widget>[
      //     Flexible(child: child),
      //     SizedBox(height: headerHeight),
      //   ],
      // ),
      background: child,
      persistentHeader: _buildHeader(context),
      expandableContent: Container(
        color: bgColor,
        child: sheet,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final gripper = Container(
      decoration: BoxDecoration(
        color: Color(0xFFC3C2C0),
        borderRadius: BorderRadius.circular(5),
      ),
      width: 35,
      height: 5,
    );
    return Container(
      height: headerHeight,
      child: Center(
        child: gripper,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withAlpha(60),
            blurRadius: 0.4,
            offset: Offset(0, 0.1),
          ),
          BoxShadow(
            color: Color(0xFF000000).withAlpha(70),
            blurRadius: 1.8,
            offset: Offset(0, 0.8),
          ),
        ],
      ),
    );
  }
}
