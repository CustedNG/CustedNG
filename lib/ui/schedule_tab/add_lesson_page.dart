import 'dart:ui';

import 'package:custed2/config/theme.dart';
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
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';

class AddLessonPage extends StatefulWidget {
  AddLessonPage();

  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  final nameController = TextEditingController(text: '自定义课程1');
  final roomController = TextEditingController(text: '');
  final teacherController = TextEditingController(text: '');
  final weeksController = TextEditingController();
  final weekdayController = TextEditingController();
  final sectionController = TextEditingController();

  var weeks = Map<int, bool>.fromIterables(
    List<int>.generate(24, (index) => index + 1),
    List<bool>.generate(24, (index) => index <= 2),
  );

  var weekday = 1;
  var startSection = 1;
  var endSection = 2;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: CupertinoColors.lightBackgroundGray,
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarButton.close(onPressed: () => Navigator.pop(context)),
        middle: Text('添加课程', style: navBarText),
        trailing: NavBarButton.trailing(
          child: Text('提交', style: navBarText),
          onPressed: _addLesson,
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
      ..endSection = endSection;

    final store = await locator.getAsync<CustomLessonStore>();
    final snake = locator<SnakebarProvider>();
    
    store.addLesson(lesson);
    locator<ScheduleProvider>().loadLocalData();

    snake.info('添加成功');
    Navigator.pop(context);
  }
}
