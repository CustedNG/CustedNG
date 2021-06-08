import 'package:custed2/config/routes.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeExam extends StatefulWidget {
  @override
  _HomeExamState createState() => _HomeExamState();
}

class _HomeExamState extends State<HomeExam> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final exam = Provider.of<ExamProvider>(context);
    final setting = locator<SettingStore>();

    if (!exam.show || user.isBusy || !user.loggedIn) {
      return Container();
    }

    if (exam.isBusy || exam == null) {
      return HomeCard.loading();
    }

    String time = '';
    String notice = '';

    if (setting.agreeToShowExam.fetch() == false) {
      notice = '点击查看考场信息';
    } else if (exam.data == null) {
      notice = '无数据，请点击进入此卡片并刷新';
    } else if (exam.failed) {
      notice = '刷新失败，暂时无法获取考试信息 ${(exam.useCache) ? "(缓存)" : ""}';
    } else {
      var nextExam = exam.getNextExam();
      if (nextExam == null) {
        notice = '没有考试啦～ ${(exam.useCache) ? "(缓存)" : ""}';
      } else {
        final examName = nextExam.examTask.beginLesson.lessonInfo.name;
        final examPosition = nextExam.examTask.examRoom.name;
        final examType = nextExam.examTask.type;

        var examTime = nextExam.examTask.beginDate.substring(0, 11) +
            nextExam.examTask.beginTime;
        examTime = examTime
            .substring(5)
            .replaceFirst('-', ' ~ ', 6)
            .replaceFirst('-', '月')
            .replaceFirst(' ', '日 ');

        time = examTime;
        if (exam.useCache) {
          final failedTip = '(缓存)';
          notice = '$examName \n$examPosition  $examType $failedTip';
        } else {
          notice = '$examName \n$examPosition  $examType';
        }
      }
    }

    final style = TextStyle(
      fontSize: 13,
    );

    final card = HomeCard(
      title: _buildTitle(context, time),
      trailing: true,
      content: Text(notice, style: style),
    );

    final heroIndex =
        exam.data == null ? 0 : exam.data.total - exam.getRemainExam();

    final child = Hero(
      tag: 'ExamCard$heroIndex',
      transitionOnUserGestures: true,
      child: card,
    );

    return GestureDetector(
      onTap: () => examPage.go(context),
      child: child,
    );
  }

  Widget _buildTitle(BuildContext context, String examTime) {
    final style = TextStyle(
      color: resolveWithBackground(context),
      fontWeight: FontWeight.bold,
    );
    final title = '下场考试 $examTime';
    return Text(title, style: style);
  }
}
