import 'dart:async';

import 'package:custed2/ui/theme.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleWeekNavigator extends StatefulWidget {
  ScheduleWeekNavigator();

  @override
  _ScheduleWeekNavigatorState createState() => _ScheduleWeekNavigatorState();
}

class _ScheduleWeekNavigatorState extends State<ScheduleWeekNavigator> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final hasSchedule = scheduleProvider.schedule != null;
    final iconColorWithAlpha = Theme.of(context).iconTheme.color.withOpacity(0.2);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.scheduleOutlineColor,
          width: hasSchedule ? 0 : 1,
        ),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildRoundButton(context, '第${scheduleProvider.selectedWeek}周',
              onPressed: () => _openPicker(context),
              onLongPress: scheduleProvider.gotoCurrentWeek),
          Text('${scheduleProvider.activeLessonCount ?? 0} 节'),
          _ArrowButton(
              icon: scheduleProvider.selectedWeek > (scheduleProvider.minWeek ?? 0)
                  ? Icon(Icons.arrow_back_ios)
                  : Icon(Icons.arrow_back_ios, color: iconColorWithAlpha),
              onPressed: scheduleProvider.gotoPrevWeek),
          _ArrowButton(
              icon: scheduleProvider.selectedWeek < (scheduleProvider.maxWeek ?? 0)
                  ? Icon(Icons.arrow_forward_ios)
                  : Icon(Icons.arrow_forward_ios, color: iconColorWithAlpha),
              onPressed: scheduleProvider.gotoNextWeek),
        ],
      ),
    );
  }

  Widget _buildRoundButton(
    BuildContext context,
    String text, {
    onPressed(),
    onLongPress(),
  }) {
    return TextButton(
      onLongPress: onLongPress,
      onPressed: onPressed,
      style: ButtonStyle(
        enableFeedback: true,
        backgroundColor: MaterialStateProperty.all(Colors.black12),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          )
        )
      ),
      child: SizedBox(
        height: 27,
        width: 87,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1.color.withAlpha(127)
            ),
          ),
        ),
      ),
    );
  }

  void _openPicker(BuildContext context) async {
    final scheduleProvider = locator<ScheduleProvider>();
    if (scheduleProvider.schedule == null) {
      return;
    }

    final TextStyle textStyle = TextStyle(
        fontSize: 17.0,
    );
    var selected = 
      scheduleProvider.selectedWeek.clamp(1, scheduleProvider.maxWeek);

    final items = List<Widget>.generate(scheduleProvider.maxWeek, (i) {
      final String text =
          i + 1 == scheduleProvider.currentWeek 
          ? '第${i + 1}周 - 当前周' : '第${i + 1}周';

      return Center(
        child: Text(
          text,
          style: textStyle,
        ),
      );
    });

    await showRoundDialog(
      context,
      '选择周数',
      Stack(
        children: [
          Positioned(
            child: Container(
              height: 37,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.black12,
              ),
            ),
            top: 55,
            bottom: 55,
            left: 0,
            right: 0,
          ),
          Container(
            height: 150.0,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 37,
              diameterRatio: 1.2,
              onSelectedItemChanged: (n) => setState(() {
                scheduleProvider.selectWeek(n + 1);
              }),
              controller: FixedExtentScrollController(initialItem: selected - 1),
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) =>
                      items[index],
                  childCount: items.length
              ),
            ),
          ),
        ],
      ),
      []
    );
  }
}

class _ArrowButton extends StatefulWidget {
  _ArrowButton({this.icon, this.onPressed});

  final Icon icon;
  final Function() onPressed;

  @override
  __ArrowButtonState createState() => __ArrowButtonState();
}

class __ArrowButtonState extends State<_ArrowButton> {
  Timer longPressTimer;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onLongPressStart: (_) => activateTimer(),
      onLongPressEnd: (_) => cancelTimer(),
      child: IconButton(
        onPressed: widget.onPressed,
        padding: EdgeInsets.all(10),
        icon: widget.icon,
      ),
    );
  }

  void activateTimer() {
    longPressTimer =
        Timer.periodic(Duration(milliseconds: 200), (_) => widget.onPressed());
  }

  void cancelTimer() => longPressTimer?.cancel();
}
