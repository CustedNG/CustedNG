import 'dart:async';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/util/time_point.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:flutter/material.dart';

class ScheduleArrow extends StatefulWidget {
  ScheduleArrow({this.child, this.schedule, this.hideWeekend});

  final Widget child;
  final Schedule schedule;
  final double iconSize = 20.0;
  final bool hideWeekend;

  @override
  _ScheduleArrowState createState() => _ScheduleArrowState();
}

class _ScheduleArrowState extends State<ScheduleArrow> {
  Timer updateTimer;

  @override
  void initState() {
    updateTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    updateTimer == null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        _buildArrowFrame(),
      ],
    );
  }

  Widget _buildArrowFrame() {
    return FractionallySizedBox(
      widthFactor: calcWidthFactor(),
      alignment: Alignment.bottomRight,
      child: SizedBox(
        height: calcTop(),
        child: _buildArrow(),
      ),
    );
  }

  Widget _buildArrow() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Icon(Icons.forward,
          color: resolveWithBackground(context) ?? Colors.red),
    );
  }

  double calcWidthFactor() {
    int total = widget.hideWeekend ? 5 : 7;
    final now = DateTime.now().weekday - 0.8;
    return now / total;
  }

  double calcTop() {
    const sectionOffset = 104.5;
    final now = DateTime.now();
    final sec = _sections.firstWhere((s) => s.contains(now));
    final topBase = (sec.startSection - 1) * sectionOffset;
    final msSinceStart =
        TimePoint.fromDateTime(now).substract(sec.start).inMilliseconds;
    final msLength = sec.duration.inMilliseconds;
    final topFractional =
        sec.length * sectionOffset * (msSinceStart / msLength);
    final topOffset = widget.iconSize / 2 + 3;
    return topBase + topFractional + topOffset;
  }
}

class _ArrowSection {
  _ArrowSection(this.start, this.end, this.startSection, this.length);

  TimePoint start;
  TimePoint end;
  int startSection;
  int length;

  bool contains(DateTime time) =>
      start.isBeforeOrSameAs(time) && end.isAfterOrSameAs(time);

  Duration get duration => end.substract(start);
}

final _sections = [
  _ArrowSection('00:00'.tp, '08:00'.tp, 1, 0), // 上课前
  _ArrowSection('08:00'.tp, '09:35'.tp, 1, 1),
  _ArrowSection('09:35'.tp, '10:05'.tp, 2, 0),
  _ArrowSection('10:05'.tp, '11:40'.tp, 2, 1),
  _ArrowSection('11:40'.tp, '13:30'.tp, 3, 0), // 午休
  _ArrowSection('13:30'.tp, '15:05'.tp, 3, 1),
  _ArrowSection('15:05'.tp, '15:35'.tp, 4, 0),
  _ArrowSection('15:35'.tp, '17:10'.tp, 4, 1),
  _ArrowSection('17:10'.tp, '18:00'.tp, 5, 0), // 晚间
  _ArrowSection('18:00'.tp, '19:35'.tp, 5, 1),
  _ArrowSection('19:35'.tp, '19:45'.tp, 6, 0),
  _ArrowSection('19:45'.tp, '21:20'.tp, 6, 1),
  _ArrowSection('21:20'.tp, '24:00'.tp, 7, 0), // 直到半夜
];
