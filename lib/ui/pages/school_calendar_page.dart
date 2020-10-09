import 'package:custed2/ui/pages/school_calendar_menu.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/res/image_res.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SchoolCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('校历', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [NavBarMoreBtn(onTap: () => _showMenu(context))],
      ),
      body: ClipRect(
        child: SafeArea(
          child: DarkModeFilter(
            level: 160,
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
    showDialog(
      context: context,
      builder: (context) => SchoolCalendarMenu(),
    );
  }
}
