import 'package:after_layout/after_layout.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    final setting = locator<SettingStore>();
    final exam = Provider.of<ExamProvider>(context);

    Widget content = Container();

    // 两种特殊情况：
    // 1.没有考试
    // 2.不同意

    if (setting.agreeToShowExam.fetch() == true) {
      final rows = exam.data.rows;
      final list = <Widget>[];

      for (JwExamRows eachExam in rows) {
        final examTime = eachExam.examTask.beginDate.substring(5, 11) +
            eachExam.examTask.beginTime;
        final examPosition = eachExam.examTask.examRoom.name;
        final examType = eachExam.examTask.type;
        final examName = eachExam.examTask.beginLesson.lessonInfo.name;

        HomeCard homeCard = HomeCard(
          title: Text(
              examTime,
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 17, color: Color(0xFF889CC3))
          ),
          content: Text(
              '$examName  $examPosition  $examType',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 13)
          ),
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

    return Scaffold(
      backgroundColor: AppTheme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(left: 27, right: 27),
        child: content,
      ),
      appBar: NavBar.material(
        context: context,
        leading: BackIcon(),
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

    Future.delayed(Duration(milliseconds: 377), () =>
        showDialog(
          context: context,
          builder: (innerContext) {
            return CardDialog(
              title: Text('提示'),
              child: Text('\n  考场信息仅供参考\n  请与教务系统中信息核对后使用'),
              actions: [
                FlatButton(
                  child: Text('取消'),
                  onPressed: () async {
                    await Navigator.of(innerContext).pop();
                    await Future.delayed(Duration(milliseconds: 377));
                    await Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('好的'),
                  onPressed: () {
                    setting.agreeToShowExam.put(true);
                    setState(() {});
                    Navigator.of(innerContext).pop();
                  },
                ),
              ],
            );
          },
        )
    );
  }
}