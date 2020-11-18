import 'package:custed2/config/routes.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_banner.dart';
import 'package:custed2/ui/home_tab/home_drawer.dart';
import 'package:custed2/ui/home_tab/home_entries.dart';
import 'package:custed2/ui/home_tab/home_exam.dart';
import 'package:custed2/ui/home_tab/home_notice.dart';
import 'package:custed2/ui/home_tab/home_schedule.dart';
import 'package:custed2/ui/home_tab/home_weather.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<UserProvider>(context);
    final theme = AppTheme.of(context);

    if (user.isBusy) {
      return PlaceholderWidget(isActive: true);
    }

    return Scaffold(
      drawer: _buildDrawer(context, user),
      backgroundColor: theme.homeBackgroundColor,
      appBar: NavBar.material(
        context: context,
        leading: Builder(builder: (context) => IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () => Scaffold.of(context).openDrawer(),
        )),
        middle: HomeWeather(),
        trailing: <Widget>[_showMenu(context)],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildDrawer(BuildContext context, UserProvider user){
    return HomeDrawer(
        version: BuildData.build.toString(),
        myTheme: Theme.of(context),
        user: user,
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
        HomeExam(),
        HomeEntries(),
      ],
    );

    widget = ListView(
      children: <Widget>[
        Container(margin: EdgeInsets.all(20), child: widget),
      ],
    );

    return widget;
  }

  SelectView(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
        value: id,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon, color: Colors.blue),
            SizedBox(width: 10.0),
            Text(text),
          ],
        ));
  }

  Widget _showMenu(BuildContext context) {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) =>
        <PopupMenuItem<String>>[
          this.SelectView(Icons.calendar_view_day, '查看校历', 'A'),
          this.SelectView(Icons.monitor, '状态监测', 'C'),
        ],
        onSelected: (String action) {
          switch (action) {
            case 'A':
              schoolCalendarPage.go(context);
              break;
            case 'C':
              statusWebPage.go(context);
              break;
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
