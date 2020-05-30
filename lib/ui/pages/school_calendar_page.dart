import 'package:custed2/ui/pages/school_calendar_menu.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/res/image_res.dart';
import 'package:photo_view/photo_view.dart';

class SchoolCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: '主页',
        backgroundColor: CupertinoColors.black,
        actionsForegroundColor: CupertinoColors.white,
        middle: Text('校历', style: TextStyle(color: CupertinoColors.white)),
        trailing: NavBarMoreBtn(onTap: () => _showMenu(context)),
      ),
      child: ClipRect(
        child: SafeArea(
          child: DarkModeFilter(
            child: PhotoView(
              maxScale: 1.0,
              minScale: 0.1,
              imageProvider: ImageRes.miscSchoolCalendar,
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SchoolCalendarMenu(),
    );
  }
}
