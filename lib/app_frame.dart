import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/grade_tab/grade_legacy.dart';
import 'package:custed2/ui/home_tab/home_tab.dart';
import 'package:custed2/ui/nav_tab/nav_tab.dart';
import 'package:custed2/ui/schedule_tab/schedule_tab.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/user_tab/user_tab.dart';
import 'package:custed2/ui/widgets/url_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> with AfterLayoutMixin<AppFrame> {
  double _width;
  int _selectIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectIndex = locator<SettingStore>().useScheduleAsHome.fetch() ? 1 : 2;
    _pageController = PageController(initialPage: _selectIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          GradeReportLegacy(),
          ScheduleTab(),
          HomeTab(),
          NavTab(),
          UserTab(),
        ],
      ),
      bottomNavigationBar: _buildBottom(context),
    );
  }

  static const List<Icon> items = [
    Icon(Icons.leaderboard, size: 22),
    Icon(Icons.calendar_today, size: 20),
    Icon(Icons.home, size: 24),
    Icon(Icons.navigation, size: 22),
    Icon(Icons.settings, size: 22)
  ];

  Widget _buildItem(int idx, Icon item, bool isSelected) {
    bool isDarkMode = isDark(context);
    final width = _width / items.length;
    return AnimatedContainer(
      duration: Duration(milliseconds: 377),
      curve: Curves.fastOutSlowIn,
      height: 50,
      width: isSelected ? width : width - 17,
      decoration: isSelected
          ? BoxDecoration(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              borderRadius: const BorderRadius.all(Radius.circular(50)))
          : null,
      child: IconButton(
        icon: item,
        splashRadius: width / 3.3,
        padding: EdgeInsets.only(left: 17, right: 17),
        onPressed: () {
          setState(() {
            _selectIndex = idx;
            _pageController.animateToPage(idx,
                duration: Duration(milliseconds: 677),
                curve: Curves.fastLinearToSlowEaseIn);
          });
        },
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return SafeArea(
        child: Container(
      height: 56,
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 8),
      width: _width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          int itemIndex = items.indexOf(item);
          return _buildItem(itemIndex, item, _selectIndex == itemIndex);
        }).toList(),
      ),
    ));
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    locator<AppProvider>().setContext(context);
    await agreeUserAgreement(context, setting);
    try {
      await CustedService().isServiceAvailable();
    } catch (e) {
      showSnackBar(context, '无法连接到服务器，请等待修复');
      rethrow;
    }
  }

  Future<void> agreeUserAgreement(
      BuildContext context, SettingStore setting) async {
    if (setting.userAgreement.fetch()) return;
    print('[USER] User Agreement not agreed');

    await showRoundDialog(
        context,
        '使用须知',
        UrlText(
          '是否已阅读并同意《 https://res.lolli.tech/service_agreement.txt 》？',
          replace: '用户协议',
        ),
        [
          TextButton(onPressed: () => SystemNavigator.pop(), child: Text('否')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setting.userAgreement.put(true);
              },
              child: Text('是')),
        ]);

    await showRoundDialog(context, '您是否是研究生？', SizedBox(), [
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text('否')),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setting.isGraduate.put(true);
          },
          child: Text('是')),
    ]);
  }
}
