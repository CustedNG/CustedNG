import 'package:custed2/config/routes.dart';
import 'package:custed2/core/script.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_banner.dart';
import 'package:custed2/ui/home_tab/home_entries.dart';
import 'package:custed2/ui/home_tab/home_iecard.dart';
import 'package:custed2/ui/home_tab/home_notice.dart';
import 'package:custed2/ui/home_tab/home_schedule.dart';
import 'package:custed2/ui/home_tab/home_weather.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final version = BuildData.build.toString();
    final my_theme = Theme.of(context);

    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.only(), children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('CustedNG'),
          accountEmail: Text('Version: Material 1.0.$version'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/icon/custed_lite.png'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.new_releases),
          title: Text('版本信息'),
          onTap: () => {aboutPage.go(context)},
          onLongPress: () => {debugPage.go(context)},
        ),
        AboutListTile(
          icon: Icon(Icons.text_snippet),
          child: Text("开源"),
          applicationName: "CustedNG",
          applicationVersion: version,
          applicationIcon: Image.asset(
            'assets/icon/custed_lite.png',
            width: 64.0,
            height: 64.0,
          ),
          aboutBoxChildren: <Widget>[
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  style: my_theme.textTheme.bodyText1,
                  text: 'By Toast Studio\n开源地址：'),
              TextSpan(
                  style: my_theme.textTheme.bodyText1
                      .copyWith(color: my_theme.accentColor),
                  text: 'https://github.com/CustedNG/CustedNG')
            ]))
          ],
        ),
      ])),
      backgroundColor: theme.homeBackgroundColor,
      appBar: NavBar.material(
        context: context,
        middle: HomeWeather(),
        trailing: <Widget>[_showMenu(context)],
      ),
      body: _buildContent(context),
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

  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            SizedBox(width: 10.0),
            new Text(text),
          ],
        ));
  }

  Widget _showMenu(BuildContext context) {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) =>
        <PopupMenuItem<String>>[
          this.SelectView(Icons.calendar_today, '查看校历', 'A'),
          this.SelectView(Icons.feedback, '有bug？', 'B'),
          this.SelectView(Icons.question_answer, '状态监测', 'C'),
        ],
        onSelected: (String action) {
          switch (action) {
            case 'A':
              schoolCalendarPage.go(context);
              break;
            case 'B':
              runScript('bug_report.cl', context);
              break;
            case 'C':
              statusWebPage.go(context);
              break;
          }
        });
  }
}
