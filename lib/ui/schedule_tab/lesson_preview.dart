import 'dart:ui';

import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_page.dart';
import 'package:custed2/ui/schedule_tab/lesson_detail_page.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LessonInfo extends StatelessWidget {
  const LessonInfo({
    Key key,
    @required this.lesson,
    this.deviceWidth
    // this.children,
  }) : super(key: key);

  // final List<Widget> children;
  final ScheduleLesson lesson;
  final deviceWidth;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          SizedBox(height: 20),
          _buildData(context, deviceWidth),
        ],
      ),
    );
  }

  Widget _buildData(BuildContext context, double width) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDataItem(
                '时间', '${lesson.startTime ?? ''}~${lesson.endTime ?? ''}'),
            SizedBox(height: 7),
            _buildDataItem('地点', lesson.roomRaw),
          ],
        ),
        SizedBox(width: width * 0.01),
        _buildDataItem('教师', lesson.teacherName),
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

    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              lesson.displayName,
              style: titleText,
              overflow: TextOverflow.fade,
              maxLines: 3,
            ),
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.chevron_right,
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
  LessonPreview(
    this.lesson, {
    this.isCustomed = false,
    this.conflict,
  });

  final ScheduleLesson lesson;
  final bool isCustomed;
  final List<ScheduleLesson> conflict;

  bool get noConflict => conflict == null || conflict.isEmpty;

  Iterable<ScheduleLesson> get customLessons sync* {
    if (lesson.isCustom) yield lesson;
    yield* conflict.where((l) => l.isCustom);
  }

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[];
    final actions = <Widget>[];
    final deviceWidth = MediaQuery.of(context).size.width;
    content.add(LessonInfo(lesson: lesson, deviceWidth: deviceWidth));

    if (noConflict) {
      final map = Maps.search(lesson.roomRaw);
      if (map != null) {
        content.add(SizedBox(
          height: 270 * 0.618,
          child: ClipRect(child: DarkModeFilter(child: map, level: 170)),
        ));
      }
    } else {
      for (var lesson in conflict) {
        final div = Divider(
          height: 1,
          color: Colors.grey,
        );
        content.add(div);
        content.add(LessonInfo(lesson: lesson, deviceWidth: deviceWidth));
      }
    }

    actions.add(_buildActions(context));

    return CardDialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: content),
      actions: actions,
    );
  }

  Widget _buildActions(BuildContext context) {
    final confirm = FlatButton(
      child: Text('确定'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final delete = FlatButton(
      child: Text('编辑'),
      onPressed: () async {
        Navigator.of(context).pop();
        // await lesson.delete();
        AppRoute(
          title: '编辑课程',
          page: AddLessonPage(lesson: lesson),
        ).popup(context);
        locator<ScheduleProvider>().loadLocalData();
      },
    );

    final deleteCustom = FlatButton(
      child: Text('编辑自定义'),
      onPressed: () async {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                actions: List<Widget>.of(
                    customLessons.map((selectedLesson) => FlatButton(
                          child: Text(selectedLesson.displayName),
                          onPressed: () {
                            Navigator.of(context).pop();
                            AppRoute(
                              title: '编辑课程',
                              page: AddLessonPage(lesson: selectedLesson),
                            ).popup(context);
                            locator<ScheduleProvider>().loadLocalData();
                          },
                        )
                    )
                )
            )
        );
        locator<ScheduleProvider>().loadLocalData();
      },
    );

    final helpMe = FlatButton(
      child: Text('我该怎么办?'),
      onPressed: () {},
    );

    if (noConflict) {
      if (!lesson.isCustom) {
        return confirm;
      } else {
        return Row(
          children: <Widget>[
            Flexible(child: delete),
            Flexible(child: confirm),
          ],
        );
      }
    } else {
      if (customLessons.isEmpty) {
        return Row(
          children: <Widget>[
            Flexible(child: helpMe),
            Flexible(child: confirm),
          ],
        );
      } else {
        return Row(
          children: <Widget>[
            Flexible(child: deleteCustom),
            Flexible(child: confirm),
          ],
        );
      }
    }
  }
}
