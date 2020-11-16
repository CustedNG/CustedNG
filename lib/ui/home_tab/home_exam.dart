import 'dart:convert';
import 'package:custed2/data/models/exam.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeExam extends StatefulWidget {
  @override
  _HomeExamState createState() => _HomeExamState();
}

class _HomeExamState extends State<HomeExam> {
  Exam exam;
  bool showExam = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showExam = await CustedService().getShouldShowExam();
      setState(() {});
      if(showExam) exam = Exam.fromJson(json.decode(await JwService().getExam()));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!showExam) return Container();
    if(exam == null) return Center(child: CupertinoActivityIndicator());

    String examName;
    String examPosition;
    String examType;
    String examTime;

    List rows = exam.data.rows;
    rows.sort((i, ii) => sortByTime(i, ii));
    for(Rows eachExam in rows){
      examTime = eachExam.examTask.kSRQ.substring(0, 11)
          + eachExam.examTask.kSSF;
      if(DateTime.parse(examTime).isAfter(DateTime.now())){
        examPosition = eachExam.examTask.examRoom.kCMC;
        examType = eachExam.examTask.kSXS;
        examName = eachExam.examTask.beginLesson.lessonInfo.kCMC;
      }

    }

    return GestureDetector(
      onTap: () => showCupertinoDialog(
          context: context,
          builder: (ctx) {
            List<Widget> list = [];
            for(Rows eachExam in rows){
              examTime = eachExam.examTask.kSRQ.substring(5, 11)
                  + eachExam.examTask.kSSF;
              examPosition = eachExam.examTask.examRoom.kCMC;
              examType = eachExam.examTask.kSXS;
              examName = eachExam.examTask.beginLesson.lessonInfo.kCMC;
              list.add(Text(examTime, style: TextStyle(fontSize: 17)));
              list.add(Text('$examName \n$examPosition \n$examType'));
              list.add(SizedBox(height: 15));
            }
            return CupertinoAlertDialog(
              content: Column(children: list),
            );
          }
      ),
      child: HomeCard(
        title: _buildTitle(context, examTime.substring(5)),
        trailing: _buildArrow(),
        content: Text('$examName \n$examPosition $examType'),
      ),
    );
  }

  int sortByTime(Rows i, Rows ii) =>
      ii.examTask.kSRQ.compareTo(i.examTask.kSRQ);

  Widget _buildTitle(BuildContext context, String exam) {
    final style = TextStyle(
      color: Color(0xFF889CC3),
    );

    final title = '下场考试 $exam';

    return Text(exam == '' ? '点击获取考试表' : title, style: style);
  }

  Widget _buildArrow() {
    return Icon(
      CupertinoIcons.right_chevron,
      color: CupertinoColors.black.withAlpha(100),
    );
  }
}