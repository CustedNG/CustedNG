import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/util/time_point.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_page.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with AfterLayoutMixin {
  final refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final setting = locator<SettingStore>();
    final exam = Provider.of<ExamProvider>(context);

    Widget content = Container();

    // 三种特殊情况：
    // 1.没有考试
    // 2.不同意
    // 3.教务炸了

    if (exam.isBusy) {
      content = Center(child: CircularProgressIndicator());
    } else if (setting.agreeToShowExam.fetch() == true) {
      final rows = exam?.data?.rows ?? <JwExamRows>[];
      final list = <Widget>[];

      if (exam.failed) {
        final hint = rows.isEmpty
            ? '数据获取失败 可尝试下拉刷新' //
            : '请注意：刷新失败，正在使用缓存，可能考试表不准确';

        list.add(
          Text(hint, style: TextStyle(color: Colors.red)),
        );
      }

      for (JwExamRows eachExam in rows) {
        final examTime = (eachExam.examTask.beginDate.substring(5, 11) +
                eachExam.examTask.beginTime)
            .replaceFirst('-', ' ~ ', 6)
            .replaceFirst('-', '月')
            .replaceFirst(' ', '日 ');

        final examPosition = eachExam.examTask.examRoom.name;
        final examType = eachExam.examTask.type;
        final examName = eachExam.examTask.beginLesson.lessonInfo.name;

        final homeCard = HomeCard(
          title: Text(
            examTime,
            style: TextStyle(
              color: Color(0xFF889CC3),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '$examName\n$examPosition  $examType',
            style: TextStyle(fontSize: 13),
          ),
        );

        final heroIndex = list.length ~/ 2;

        final content = Hero(
          child: homeCard,
          transitionOnUserGestures: true,
          tag: 'ExamCard$heroIndex',
        );

        final card = GestureDetector(
          child: content,
          onTap: () {
            final schedule = locator<ScheduleProvider>();
            final beginDate = DateTime.tryParse(eachExam.examTask.beginDate);
            final week = schedule.schedule.calculateWeekSinceStart(beginDate);
            final startTime = eachExam.examTask.beginTime.substring(0, 5);
            final endTime = eachExam.examTask.beginTime.substring(6, 11);
            final startSection = assumeStartSection(startTime);
            final endSection = startSection + 1;
            AppRoute(
              title: '添加课程',
              page: AddLessonPage(
                name: examName,
                room: examPosition,
                teacher: examType,
                weekday: beginDate?.weekday,
                weeks: [week],
                startTime: startTime,
                endTime: endTime,
                startSection: startSection,
                endSection: endSection,
              ),
            ).go(context);
          },
        );

        list.add(card);
        list.add(SizedBox(height: 15));
      }

      content = ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 37),
          ...list,
          SizedBox(height: 20),
        ],
      );

      if (list.isEmpty) {
        content = Center(
          child: Text(exam.data == null ? '暂时无法获取考场信息' : '没有考试啦～'),
        );
      }

      content = SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        physics: BouncingScrollPhysics(),
        header: MaterialClassicHeader(),
        controller: refreshController,
        child: content,
        onRefresh: () async {
          await exam.refreshData();
          if (exam.failed) {
            refreshController.refreshFailed();
          } else {
            refreshController.refreshCompleted();
          }
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 27, right: 27),
        child: content,
      ),
      appBar: NavBar.material(
        context: context,
        middle: NavbarText('考试安排'),
        trailing: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => showSnackBar(context, '点击卡片可添加至课表'),
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final setting = locator<SettingStore>();

    if (setting.agreeToShowExam.fetch() == true) {
      final exam = Provider.of<ExamProvider>(context, listen: false);
      exam.refreshData();
      return;
    }

    Future.delayed(
      Duration(milliseconds: 777),
      () => showRoundDialog(
        context,
        '提示',
        Text('考场信息仅供参考\n请与教务系统中信息核对后使用'),
        [
          TextButton(
            child: Text('取消'),
            onPressed: () async {
              await Navigator.of(context).pop();
              await Future.delayed(Duration(milliseconds: 377));
              await Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('好的'),
            onPressed: () {
              setting.agreeToShowExam.put(true);
              setState(() {});
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

int assumeStartSection(String time) {
  final times = {
    TimePoint(9, 35): 1,
    TimePoint(11, 40): 3,
    TimePoint(15, 05): 5,
    TimePoint(17, 10): 7,
    TimePoint(19, 35): 9,
    TimePoint(21, 20): 11,
  };

  final timePoint = TimePoint.fromString(time);

  for (var time in times.entries) {
    if (timePoint.minutes < time.key.minutes) {
      return time.value;
    }
  }

  return times.values.last;
}
