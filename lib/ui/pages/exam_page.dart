import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamPage extends StatelessWidget{
  final JwExam exam;

  const ExamPage({Key key, this.exam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    List rows = exam.data.rows;
    String examName;
    String examPosition;
    String examType;
    String examTime;

    rows.sort((i, ii) => sortByTime(ii, i));
    for(JwExamRows eachExam in rows){
      examTime = eachExam.examTask.kSRQ.substring(5, 11)
          + eachExam.examTask.kSSF;
      examPosition = eachExam.examTask.examRoom.kCMC;
      examType = eachExam.examTask.kSXS;
      examName = eachExam.examTask.beginLesson.lessonInfo.kCMC;

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

    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: list,
            ),
          )
        ],
      ),
      backgroundColor: AppTheme.of(context).backgroundColor,
      appBar: NavBar.material(
        context: context,
        middle: NavbarText('考试安排')
      ),
    );
  }

  int sortByTime(JwExamRows i, JwExamRows ii) =>
      ii.examTask.kSRQ.compareTo(i.examTask.kSRQ);
}