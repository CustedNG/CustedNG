import 'dart:ui';

import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/store/custom_lesson_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_field.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_time.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_time_picker.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_weeks_picker.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';

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
  final sectionController = TextEditingController();

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

    return CupertinoPageScaffold(
      backgroundColor: theme.textFieldListBackgroundColor,
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarButton.close(onPressed: () => Navigator.pop(context)),
        middle: Text('添加课程', style: navBarText),
        trailing: NavBarButton.trailing(
          child: Text('提交', style: navBarText),
          onPressed: () {
            if (widget.lesson != null) {
              widget.lesson.delete();
            }
            _addLesson();
          },
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.textColor,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 16),
            _buildNameField(context),
            SizedBox(height: 12),
            _buildRoomField(context),
            _buildTeacherField(context),
            _buildWeekField(context),
            _buildTimeField(context),
            if (widget.lesson != null) _buildDeleteButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AddLessonField(
      CupertinoIcons.book_solid,
      placeholder: '课程名称',
      controller: nameController,
      isPrimary: true,
    );
  }

  Widget _buildRoomField(BuildContext context) {
    return AddLessonField(
      CupertinoIcons.location_solid,
      placeholder: '教室',
      controller: roomController,
    );
  }

  Widget _buildTeacherField(BuildContext context) {
    return AddLessonField(
      CupertinoIcons.person_solid,
      placeholder: '老师',
      controller: teacherController,
    );
  }

  Widget _buildWeekField(BuildContext context) {
    return AddLessonField(
      CupertinoIcons.time_solid,
      placeholder: '周数',
      isReadonly: true,
      controller: weeksController,
      onTap: () => _openWeekPicker(context),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: AddLessonField(
            CupertinoIcons.bell_solid,
            placeholder: '星期',
            isReadonly: true,
            controller: weekdayController,
            onTap: () => _openTimePicker(context),
          ),
        ),
        Flexible(
          flex: 2,
          child: AddLessonField(
            CupertinoIcons.bell_solid,
            placeholder: '第几节',
            isReadonly: true,
            controller: sectionController,
            onTap: () => _openTimePicker(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
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
  }

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
    weekdayController.text = weekday.weekdayInChinese();
    sectionController.text = '${startSection}-${endSection}节';
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
    final snake = locator<SnakebarProvider>();

    store.addLesson(lesson);
    locator<ScheduleProvider>().loadLocalData();

    snake.info('添加成功');
    Navigator.pop(context);
  }
}
