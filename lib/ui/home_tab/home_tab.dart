import 'package:custed2/config/routes.dart';
import 'package:custed2/ui/home_tab/home_banner.dart';
import 'package:custed2/ui/home_tab/home_entries.dart';
import 'package:custed2/ui/home_tab/home_iecard.dart';
import 'package:custed2/ui/home_tab/home_menu.dart';
import 'package:custed2/ui/home_tab/home_notice.dart';
import 'package:custed2/ui/home_tab/home_schedule.dart';
import 'package:custed2/ui/home_tab/home_weather.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/navbar/navbar_title.dart';
import 'package:flutter/cupertino.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: theme.homeBackgroundColor,
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarTitle(
          child: GestureDetector(
            child: NavbarText('Custed'),
            onTap: () => aboutPage.go(context),
            onLongPress: () => debugPage.go(context),
          ),
        ),
        middle: HomeWeather(),
        trailing: NavBarMoreBtn(onTap: () => _showMenu(context)),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HomeBanner(),
        SizedBox(height: 15),
        HomeNotice(),
        SizedBox(height: 15),
        HomeSchedule(),
        SizedBox(height: 15),
        HomeEntries(),
        SizedBox(height: 15),
        HomeIecard(),
      ],
    );

    widget = ListView(
      children: <Widget>[
        Container(margin: EdgeInsets.all(20), child: widget),
      ],
    );

    return widget;
  }

  void _showMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => HomeMenu(),
    );
  }
}
