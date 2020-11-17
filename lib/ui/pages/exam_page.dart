import 'package:custed2/data/models/exam.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';

class ExamPage extends StatelessWidget{
  final Exam exam;

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
    for(Rows eachExam in rows){
      examTime = eachExam.examTask.kSRQ.substring(5, 11)
          + eachExam.examTask.kSSF;
      examPosition = eachExam.examTask.examRoom.kCMC;
      examType = eachExam.examTask.kSXS;
      examName = eachExam.examTask.beginLesson.lessonInfo.kCMC;
      list.add(Text(
          examTime,
          textScaleFactor: 1.0,
          style: TextStyle(fontSize: 17, color: Color(0xFF889CC3))
      ));
      list.add(Text(
        '$examName $examType',
        textScaleFactor: 1.0,
        style: TextStyle(fontSize: 13)
      ));
      list.add(Text(
        examPosition,
        textScaleFactor: 1.0,
        style: TextStyle(fontSize: 13)
      ));
      list.add(SizedBox(height: 15));
    }
    return CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.only(left: 27, right: 27, top: 17),
        child: ListView(
          children: list,
        ),
      ),
      navigationBar: NavBar.cupertino(
        context: context,
        leading: GestureDetector(
          child: BackIcon(),
          onTap: () => Navigator.of(context).pop(),
        ),
        middle: NavbarText('考试安排')
      ),
    );
  }

  int sortByTime(Rows i, Rows ii) =>
      ii.examTask.kSRQ.compareTo(i.examTask.kSRQ);
}