import 'package:custed2/core/extension/color.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/user_tab/custed_more_page.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';

class CustedHeader extends StatefulWidget {
  @override
  _CustedHeaderState createState() => _CustedHeaderState();
}

class _CustedHeaderState extends State<CustedHeader> {
  @override
  Widget build(BuildContext context) {
    final priColor = primaryColor;
    final isBrightBackground = priColor.isBrightColor;
    final floatTextUseWhite =
        isDark(context) ? true : (isBrightBackground ? false : true);

    return Padding(
        padding: EdgeInsets.all(20.0),
        child: GestureDetector(
            onTap: () => AppRoute(page: CustedMorePage()).go(context),
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              semanticContainer: false,
              child: Stack(
                children: <Widget>[
                  _buildBackground(priColor),
                  _buildFloat(floatTextUseWhite),
                  _buildRightIcon(isBrightBackground)
                ],
              ),
            )));
  }

  Widget _buildRightIcon(bool isBrightBackground) {
    return Positioned(
      child: Icon(Icons.keyboard_arrow_right,
          color: isBrightBackground ? Colors.black : Colors.white),
      top: 0,
      bottom: 0,
      right: 17,
    );
  }

  Widget _buildBackground(Color primary) {
    return AspectRatio(
      aspectRatio: (MediaQuery.of(context).size.width - 40) / 110,
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withOpacity(0.8),
          primary,
        ],
      ))),
    );
  }

  Widget _buildFloat(bool floatTextUseWhite) {
    return Positioned(
        top: 0,
        left: 30,
        bottom: 0,
        child: Row(
          children: [
            Hero(
                tag: '123123',
                transitionOnUserGestures: true,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: DarkModeFilter(
                      child: Image.asset('assets/icon/custed_lite.png',
                          height: 57, width: 57),
                    ))),
            SizedBox(width: 30.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Custed NG',
                  style: TextStyle(
                      color: floatTextUseWhite ? Colors.white : Colors.black,
                      fontSize: 20),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Ver: Material 1.0.${BuildData.build}',
                  style: TextStyle(
                      color:
                          floatTextUseWhite ? Colors.white54 : Colors.black54,
                      fontSize: 15),
                )
              ],
            ),
          ],
        ));
  }
}
