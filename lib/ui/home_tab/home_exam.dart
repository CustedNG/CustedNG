import 'package:custed2/config/routes.dart';
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

    Widget loading = Column(
      children: [
        HomeCard(
          content: Padding(
            padding: EdgeInsets.all(7),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        SizedBox(height: 15)
      ],
    );

    if (exam.isBusy) {
      return loading;
    }

    if (exam == null) {
      return loading;
    }

    String time = '';
    String notice = '';

    if (setting.agreeToShowExam.fetch() == false) {
      notice = '点击查看考场信息';
    } else if (exam.failed) {
      notice = '暂时无法获取考场信息';
    } else {
      final nextExam = exam.getNextExam();
      if (nextExam == null) {
        notice = '没有考试啦～';
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
        notice = '$examName \n$examPosition  $examType';
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => examPage.go(context),
          child: Hero(
              tag: 'ExamCard${exam.failed ? 0 : 
                    exam.data.total - exam.getRemainExam()}',
              transitionOnUserGestures: true,
              child: HomeCard(
                title: _buildTitle(context, time),
                trailing: true,
                content: Text(notice),
              )
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, String examTime) {
    final style = TextStyle(color: Color(0xFF889CC3));
    final title = '下场考试 $examTime';
    return Text(title, style: style);
  }
}
