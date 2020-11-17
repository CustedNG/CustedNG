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
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLessonPage extends StatefulWidget {
  AddLessonPage({this.lesson});

  final ScheduleLesson lesson;

  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  final nameController = TextEditingController(text: '');
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
    if (widget.lesson != null) {
      nameController.text = widget.lesson.name;
      roomController.text = widget.lesson.roomRaw;
      teacherController.text = widget.lesson.teacherName;
      weeks = Map<int, bool>.fromIterables(
        List<int>.generate(24, (idx) => idx + 1),
        List<bool>.generate(24, (idx) => widget.lesson.weeks.contains(idx + 1)),
      );
      weekday = widget.lesson.weekday;
      startSection = widget.lesson.startSection;
      endSection = widget.lesson.endSection;
    }
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
      backgroundColor: theme.textFieldListBackgroundColor,
      appBar: NavBar.material(
          context: context,
          middle: Text('添加课程', style: navBarText),
          trailing: [
            NavBarButton.trailing(
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Text('提交', style: navBarText),
              ),
              onPressed: () {
                if (widget.lesson != null) {
                  widget.lesson.delete();
                }
                _addLesson();
              },
            ),
          ]),
      body: DefaultTextStyle(
        style: TextStyle(
          color: theme.textColor,
        ),
        child: ListView(
          children: <Widget>[
            _buildNameField(context),
            _buildRoomField(context),
            _buildTeacherField(context),
            _buildWeekField(context),
            _buildTimeField(context),
            //_buildDeleteButton(context)
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
    return AddLessonField(
      Icons.timer,
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
          flex: 2,
          child: AddLessonField(
            Icons.calendar_today,
            placeholder: '星期',
            isReadonly: true,
            controller: weekdayController,
            onTap: () => _openTimePicker(context),
          ),
        ),
        Flexible(
          flex: 3,
          child: AddLessonField(
            Icons.class_,
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
      child:
          Text('删除', style: TextStyle(color: CupertinoColors.destructiveRed)),
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
      ..endSection = endSection;

    final store = await locator.getAsync<CustomLessonStore>();
    
    store.addLesson(lesson);
    locator<ScheduleProvider>().loadLocalData();

    showSnackBar(context, '添加成功');
    Navigator.pop(context);
  }
}
