import 'package:after_layout/after_layout.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ExamDataSource extends CalendarDataSource {
  ExamDataSource(List<ExamData> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].subject;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}

class ExamData {
  ExamData(this.subject, this.from, this.to, this.background);

  String subject;
  DateTime from;
  DateTime to;
  Color background;
}

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with AfterLayoutMixin {
  List<ExamData> _getDataSource() {
    final exam = Provider.of<ExamProvider>(context);
    final result = <ExamData>[];

    if (exam.failed || exam.data?.rows == null) {
      return result;
    }

    final rows = exam.data.rows;

    for (var exam in rows) {
      final examTime = exam.examTask.date.substring(5, 11) + exam.examTask.time;
      final examPosition = exam.examTask.examRoom.name;
      final examType = exam.examTask.type;
      final subject = exam.examTask.beginLesson.lessonInfo.name;

      final begin = exam.examTask.date.substring(0, 11) +
          exam.examTask.time.substring(0, 5);
      final end = exam.examTask.date.substring(0, 11) +
          exam.examTask.time.substring(6, 11);

      const colors = [
        Color(0xFF3E52B2),
        Color(0xFF8A28A7),
        Color(0xFFD00A14),
        Color(0xFF1A8547),
        Color(0xFFF9582C),
        Color(0xFF1BA2EC),
        Color(0xFF40B37F),
      ];

      final color = colors[subject.hashCode % colors.length];

      result.add(ExamData(
        '$subject 111\n$examPosition  $examType',
        DateTime.parse(begin),
        DateTime.parse(end),
        color,
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        leading: GestureDetector(
          child: BackIcon(),
          onTap: () => Navigator.of(context).pop(),
        ),
        middle: NavbarText('考试安排'),
      ),
      child: SafeArea(
        child: SfCalendar(
          view: CalendarView.schedule,
          firstDayOfWeek: 1,
          dataSource: ExamDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(showAgenda: true),
          minDate: DateTime(2020, 11, 1),
          maxDate: DateTime(2020, 12, 31),
          scheduleViewSettings: ScheduleViewSettings(
            hideEmptyScheduleWeek: true,
            monthHeaderSettings: MonthHeaderSettings(height: 70),
            // weekHeaderSettings: WeekHeaderSettings(height: 0),
          ),
        ),
      ),
    );

    final setting = locator<SettingStore>();
    final exam = Provider.of<ExamProvider>(context);

    Widget content = Container();

    // 三种特殊情况：
    // 1.没有考试
    // 2.不同意
    // 3.教务炸了

    if (exam.failed) {
      content = Center(
        child: Text('暂时无法获取考场信息～'),
      );
    } else if (setting.agreeToShowExam.fetch() == true) {
      final rows = exam?.data?.rows ?? <JwExamRows>[];
      final list = <Widget>[];

      for (var eachExam in rows) {
        final examTime =
            eachExam.examTask.date.substring(5, 11) + eachExam.examTask.time;
        final examPosition = eachExam.examTask.examRoom.name;
        final examType = eachExam.examTask.type;
        final examName = eachExam.examTask.beginLesson.lessonInfo.name;

        HomeCard homeCard = HomeCard(
          title: Text(examTime,
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 17, color: Color(0xFF889CC3))),
          content: Text('$examName  $examPosition  $examType',
              textScaleFactor: 1.0, style: TextStyle(fontSize: 13)),
        );

        list.add(homeCard);
        list.add(SizedBox(height: 15));
      }

      content = ListView(
        children: [
          SizedBox(height: 27),
          ...list,
          SizedBox(height: 27),
        ],
      );

      if (list.isEmpty) {
        content = Center(
          child: Text('没有考试啦～'),
        );
      }
    }

    return CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.only(left: 27, right: 27),
        child: content,
      ),
      navigationBar: NavBar.cupertino(
        context: context,
        leading: GestureDetector(
          child: BackIcon(),
          onTap: () => Navigator.of(context).pop(),
        ),
        middle: NavbarText('考试安排'),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final setting = locator<SettingStore>();

    if (setting.agreeToShowExam.fetch() == true) {
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (innerContext) {
        return CupertinoAlertDialog(
          title: Text('提示'),
          content: Text('考场信息仅供参考\n请与教务系统中信息核对后使用'),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () async {
                await Navigator.of(innerContext).pop();
                await Future.delayed(Duration(milliseconds: 500));
                await Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('好的'),
              isDefaultAction: true,
              onPressed: () {
                setting.agreeToShowExam.put(true);
                setState(() {});
                Navigator.of(innerContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
