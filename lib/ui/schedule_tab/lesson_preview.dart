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
import 'package:flutter/material.dart' as material;

class LessonInfo extends StatelessWidget {
  const LessonInfo({
    Key key,
    @required this.lesson,
    // this.children,
  }) : super(key: key);

  // final List<Widget> children;
  final ScheduleLesson lesson;

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
            _buildDataItem(
                '上课时间', '${lesson.startTime ?? ''}~${lesson.endTime ?? ''}'),
            SizedBox(height: 10),
            _buildDataItem('上课地点', lesson.roomRaw),
          ],
        ),
        SizedBox(width: 40),
        _buildDataItem('任课教师', lesson.teacherName),
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
        Text(label ?? "", style: labelText),
        Text(value ?? "", style: valueText),
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
    content.add(LessonInfo(lesson: lesson));

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
        final div = material.Divider(
          height: 1,
          color: CupertinoColors.inactiveGray,
        );
        content.add(div);
        content.add(LessonInfo(lesson: lesson));
      }
    }

    content.add(_buildActions(context));

    return CardDialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: content),
    );
  }

  Widget _buildActions(BuildContext context) {
    final confirm = CupertinoDialogAction(
      child: Text('确定'),
      isDefaultAction: true,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final delete = CupertinoDialogAction(
      child: Text('编辑'),
      isDestructiveAction: true,
      onPressed: () async {
        Navigator.of(context).pop();
        // await lesson.delete();
        AppRoute(
          title: '编辑课程',
          page: AddLessonPage.editLesson(lesson),
        ).popup(context);
        locator<ScheduleProvider>().loadLocalData();
      },
    );

    final deleteCustom = CupertinoDialogAction(
      child: Text('编辑自定义'),
      isDestructiveAction: true,
      onPressed: () async {
        Navigator.of(context).pop();
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: List<Widget>.of(
              customLessons.map(
                (selectedLesson) => CupertinoActionSheetAction(
                  child: Text(selectedLesson.displayName),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppRoute(
                      title: '编辑课程',
                      page: AddLessonPage.editLesson(selectedLesson),
                    ).popup(context);
                    locator<ScheduleProvider>().loadLocalData();
                  },
                ),
              ),
            ),
          ),
        );
        locator<ScheduleProvider>().loadLocalData();
      },
    );

    // final helpMe = CupertinoDialogAction(
    //   child: Text('我该怎么办?'),
    //   isDestructiveAction: true,
    //   onPressed: () {},
    // );

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
            // Flexible(child: helpMe),
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
