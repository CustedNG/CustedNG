import 'dart:ui';

import 'package:custed2/config/theme.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/ui/schedule_tab/lesson_detail_page.dart';
import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:custed2/ui/widgets/maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class LessonInfo extends StatelessWidget {
  const LessonInfo({
    Key key,
    @required this.lesson,
    // this.children,
    this.isCustomed = false,
  }) : super(key: key);

  // final List<Widget> children;
  final ScheduleLesson lesson;
  final bool isCustomed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: material.MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          SizedBox(height: 10),
          _buildData(context),
        ],
      ),
    );
  }

  Widget _buildData(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDataItem('上课时间', '${lesson.startTime}~${lesson.endTime}'),
            SizedBox(height: 10),
            _buildDataItem('任课教师', lesson.teacherName),
          ],
        ),
        SizedBox(width: 40),
        _buildDataItem('上课地点', lesson.roomRaw),
      ],
    );
  }

  Widget _buildDataItem(String label, String value) {
    final labelText = const TextStyle(fontSize: 12);
    final valueText = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: labelText),
        Text(value, style: valueText),
        // if (children != null) ...children
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = AppTheme.of(context);

    final titleText = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    final title = isCustomed ? lesson.name + '(自定义)' : lesson.name;

    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: titleText,
              overflow: TextOverflow.fade,
              maxLines: 3,
            ),
          ),
          Column(
            children: <Widget>[
              Icon(
                CupertinoIcons.right_chevron,
                size: 20,
                color: theme.textColor.withAlpha(100),
              ),
              SizedBox(height: 3)
            ],
          )
        ],
      ),
      onTap: () {
        AppRoute(
          title: '课程详情',
          page: LessonDetailPage(lesson),
        ).go(context);
      },
    );
  }
}

class LessonPreview extends StatelessWidget {
  LessonPreview(this.lesson, {this.isCustomed = false});

  final ScheduleLesson lesson;
  final bool isCustomed;

  @override
  Widget build(BuildContext context) {
    final map = Maps.search(lesson.roomRaw);
    return CardDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LessonInfo(lesson: lesson),
          if (map != null)
            SizedBox(height: 270 * 0.618, child: ClipRect(child: map)),
          CupertinoDialogAction(
            child: Text('确定'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
