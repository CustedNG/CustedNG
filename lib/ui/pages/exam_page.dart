import 'package:after_layout/after_layout.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';
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
        final examTime = eachExam.examTask.beginDate.substring(5, 11) +
            eachExam.examTask.beginTime;
        final examPosition = eachExam.examTask.examRoom.name;
        final examType = eachExam.examTask.type;
        final examName = eachExam.examTask.beginLesson.lessonInfo.name;
        list.add(Text(examTime,
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 17, color: Color(0xFF889CC3))));
        list.add(Text('$examName $examType',
            textScaleFactor: 1.0, style: TextStyle(fontSize: 13)));
        list.add(Text(examPosition,
            textScaleFactor: 1.0, style: TextStyle(fontSize: 13)));
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
