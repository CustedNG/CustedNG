import 'dart:ui';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/store/custom_lesson_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_field.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_time.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_time_picker.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_weeks_picker.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLessonPage extends StatefulWidget {
  AddLessonPage({
    this.name,
    this.room,
    this.teacher,
    this.weeks,
    this.weekday,
    this.startSection,
    this.endSection,
    this.startTime,
    this.endTime,
  }) : lesson = null;

  AddLessonPage.editLesson(this.lesson)
      : name = lesson.name,
        room = lesson.roomRaw,
        teacher = lesson.teacherName,
        weeks = lesson.weeks,
        weekday = lesson.weekday,
        startSection = lesson.startSection,
        endSection = lesson.endSection,
        startTime = lesson.startTime,
        endTime = lesson.endTime;

  final String name;
  final String room;
  final String teacher;

  final List<int> weeks;
  final int weekday;

  final int startSection;
  final int endSection;

  final String startTime;
  final String endTime;

  // 已添加的课程, 可以为空
  final ScheduleLesson lesson;

  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  final nameController = TextEditingController();
  final roomController = TextEditingController();
  final teacherController = TextEditingController();
  final weeksController = TextEditingController();
  final weekdayController = TextEditingController();

  Map<int, bool> weeks;

  int weekday;
  int startSection;
  int endSection;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name ?? '自定义课程1';
    roomController.text = widget.room ?? '';
    teacherController.text = widget.teacher ?? '';

    final weeks = widget.weeks ?? [1];
    this.weeks = Map<int, bool>.fromIterables(
      List<int>.generate(24, (idx) => idx + 1),
      List<bool>.generate(24, (idx) => weeks.contains(idx + 1)),
    );

    weekday = widget.weekday ?? 1;
    startSection = widget.startSection ?? 1;
    endSection = widget.endSection ?? 2;

    updateDisplay();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final navBarText = TextStyle(
      color: theme.navBarActionsColor,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: NavBar.material(
          context: context,
          middle: Text('添加课程', style: navBarText),
          trailing: [
            FlatButton(
                onPressed: (){
                  if (widget.lesson != null) {
                    widget.lesson.delete();
                  }
                  _addLesson();
                },
                child: Text('提交', style: navBarText)
            )
          ]
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          color: theme.textColor,
        ),
        child: ListView(
          children: <Widget>[
            _buildNameField(context),
            _buildRoomField(context),
            _buildTeacherField(context),
            _buildWeekField(context)
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AddLessonField(
      Icons.book,
      placeholder: '课程名称',
      controller: nameController,
      isPrimary: true,
    );
  }

  Widget _buildRoomField(BuildContext context) {
    return AddLessonField(
      Icons.location_on,
      placeholder: '教室',
      controller: roomController,
    );
  }

  Widget _buildTeacherField(BuildContext context) {
    return AddLessonField(
      Icons.person,
      placeholder: '老师',
      controller: teacherController,
    );
  }

  Widget _buildWeekField(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: AddLessonField(
            Icons.timer,
            placeholder: '周数',
            isReadonly: true,
            controller: weeksController,
            onTap: () => _openWeekPicker(context),
          ),
        ),
        Flexible(
          flex: 3,
          child: AddLessonField(
            Icons.calendar_today,
            placeholder: '具体时间',
            isReadonly: true,
            controller: weekdayController,
            onTap: () => _openTimePicker(context),
          ),
        )
      ],
    );
  }

  /*Widget _buildDeleteButton(BuildContext context) {
    return CupertinoButton(
      child: Text(
        '删除',
        style: TextStyle(color: CupertinoColors.destructiveRed),
      ),
      onPressed: () {
        widget.lesson.delete();
        locator<ScheduleProvider>().loadLocalData();
        Navigator.pop(context);
      },
    );
  }*/

  Iterable<int> get activeWeeks {
    return weeks.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key);
  }

  void _openWeekPicker(BuildContext context) async {
    final Map<int, bool> result = await showCupertinoModalPopup(
      context: context,
      builder: (context) => AddLessonWeeksPicker(weeks),
    );
    if (result == null) return;
    weeks = result;
    updateDisplay();
  }

  void _openTimePicker(BuildContext context) async {
    final AddLessonTime result = await showCupertinoModalPopup(
      context: context,
      builder: (context) => AddLessonTimePicker(),
    );
    if (result == null) return;
    weekday = result.weekday;
    startSection = result.startSection;
    endSection = result.endSection;
    updateDisplay();
  }

  void updateDisplay() {
    weekdayController.text = weekday.weekdayInChinese() + ' ${startSection}-${endSection}节';
    weeksController.text = activeWeeks.join(',');
  }

  void _addLesson() async {
    final lesson = ScheduleLesson()
      ..name = nameController.text
      ..teacherName = teacherController.text
      ..roomRaw = roomController.text
      ..room = roomController.text
      ..type = ScheduleLessonType.custom
      ..weeks = activeWeeks.toList()
      ..weekday = weekday
      ..startSection = startSection
      ..endSection = endSection
      ..startTime = widget.startTime
      ..endTime = widget.endTime;

    final store = await locator.getAsync<CustomLessonStore>();

    store.addLesson(lesson);
    locator<ScheduleProvider>().loadLocalData();

    showSnackBar(context, '添加成功');
    Navigator.pop(context);
  }
}
