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
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/ui/widgets/select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

    if (user.isBusy) {
      return PlaceholderWidget(isActive: true);
    }

    return Scaffold(
      drawer: HomeDrawer(
        version: BuildData.build.toString(),
        myTheme: Theme.of(context),
        user: user,
      ),
      appBar: NavBar.material(
        context: context,
        leading: Builder(builder: (context) => IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => Scaffold.of(context).openDrawer(),
        )),
        middle: HomeWeather(),
        trailing: <Widget>[_showMenu(context)],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    List<Widget> widgets = [
      HomeBanner(),
      HomeNotice(),
      HomeSchedule(),
      HomeExam(),
      HomeEntries(),
      SizedBox(height: 7)
    ];

    Widget widget = AnimationLimiter(
      child: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 15, 20, 0), 
                  child: widgets[index]
                ),
              ),
            ),
          );
        },
      ),
    );

    return widget;
  }

  Widget _showMenu(BuildContext context) {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) =>
        <PopupMenuItem<String>>[
          SelectView(Icons.calendar_view_day, '查看校历', 'A', context),
          SelectView(Icons.feedback, '我要反馈', 'B', context),
        ],
        onSelected: (String action) {
          switch (action) {
            case 'A':
              schoolCalendarPage.go(context);
              break;
            case 'B':
              feedbackPage.go(context);
              break;
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
