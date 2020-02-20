import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_time.dart';
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';

class AddLessonTimePicker extends StatefulWidget {
  AddLessonTimePicker({this.weekDay, this.section});

  final int weekDay;
  final int section;

  @override
  _AddLessonTimePickerState createState() => _AddLessonTimePickerState();
}

class _AddLessonTimePickerState extends State<AddLessonTimePicker> {
  int weekDay = 1;
  int lesson = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 260.0,
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              child: CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  padding: EdgeInsetsDirectional.zero,
                  leading: NavBarButton(
                    child:
                        Align(alignment: Alignment.center, child: Text("取消")),
                    onPressed: () => Navigator.pop(context),
                  ),
                  middle: Text(
                    "选择上课时间",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  trailing: NavBarButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("确定"),
                    ),
                    onPressed: () {
                      final data = AddLessonTime(
                        weekday: weekDay,
                        startSection: lesson,
                        endSection: lesson + 1,
                      );
                      Navigator.pop(context, data);
                    },
                  ),
                  backgroundColor: CupertinoColors.lightBackgroundGray),
            ),
            Container(
              height: 200.0,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: CupertinoPicker(
                      backgroundColor: CupertinoColors.lightBackgroundGray,
                      scrollController:
                          FixedExtentScrollController(initialItem: weekDay - 1),
                      itemExtent: 30.0,
                      onSelectedItemChanged: (index) {
                        weekDay = index + 1;
                      },
                      children: List<Widget>.generate(7, (index) {
                        return Text((index + 1).weekdayInChinese());
                      }),
                    ),
                  ),
                  Flexible(
                    child: CupertinoPicker(
                      backgroundColor: CupertinoColors.lightBackgroundGray,
                      scrollController:
                          FixedExtentScrollController(initialItem: lesson ~/ 2),
                      itemExtent: 30.0,
                      onSelectedItemChanged: (index) {
                        lesson = index * 2 + 1;
                      },
                      children: List<Widget>.generate(6, (index) {
                        return Text("${index * 2 + 1}-${(index + 1) * 2}节");
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
