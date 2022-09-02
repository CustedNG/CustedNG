import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_time.dart';
import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:flutter/material.dart';

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
    return CardDialog(
      actions: [
        TextButton(
          child: Text('取消'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('确定'),
          onPressed: () {
            final data = AddLessonTime(
              weekday: weekDay,
              startSection: lesson,
              endSection: lesson + 1,
            );
            Navigator.pop(context, data);
          },
        )
      ],
      content: Container(
        height: 200.0,
        child: Row(
          children: <Widget>[
            Flexible(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: Colors.black12,
                      ),
                    ),
                    top: 47,
                    bottom: 63,
                    left: 0,
                    right: 0,
                  ),
                  Container(
                    height: 150,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 37,
                      diameterRatio: 1.2,
                      onSelectedItemChanged: (n) => setState(() {
                        weekDay = n + 1;
                      }),
                      controller:
                          FixedExtentScrollController(initialItem: weekDay - 1),
                      physics: FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) =>
                              Text((index + 1).weekdayInChinese(), textAlign: TextAlign.center,),
                          childCount: 7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 17,),
            Flexible(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: Colors.black12,
                      ),
                    ),
                    top: 47,
                    bottom: 63,
                    left: 0,
                    right: 0,
                  ),
                  Container(
                    height: 150,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 37,
                      diameterRatio: 1.2,
                      onSelectedItemChanged: (n) => setState(() {
                        lesson = n * 2 + 1;
                      }),
                      controller:
                          FixedExtentScrollController(initialItem: lesson ~/ 2),
                      physics: FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) =>
                              Text('${index * 2 + 1}-${(index + 1) * 2}节', textAlign: TextAlign.center,),
                          childCount: 6),
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
