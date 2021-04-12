import 'dart:async';

import 'package:custed2/ui/theme.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleWeekNavigator extends StatefulWidget {
  ScheduleWeekNavigator();

  @override
  _ScheduleWeekNavigatorState createState() => _ScheduleWeekNavigatorState();
}

class _ScheduleWeekNavigatorState extends State<ScheduleWeekNavigator> {
  int week;

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
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onPressed,
      child: SizedBox(
        height: 35,
        width: 100,
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

    week = scheduleProvider.selectedWeek;
    await showDialog(
      context: context,
      builder: (context) => buildPicker(
        context,
        scheduleProvider.currentWeek,
        week,
        scheduleProvider.maxWeek,
      ),
    );

    print('Week: $week');

    scheduleProvider.selectWeek(week);
  }

  Widget buildPicker(context, currentWeek, selectedWeek, maxWeek) {
    // int selected = selectedWeek;
    final TextStyle textStyle = TextStyle(
        fontSize: 22.0,
        color: isDark(context) ? Colors.white : Colors.black
    );
    var selected = selectedWeek.clamp(1, maxWeek);

    final items = List<Widget>.generate(maxWeek, (i) {
      final String text =
          i + 1 == currentWeek ? '第${i + 1}周 - 当前周' : '第${i + 1}周';

      return Center(
        child: Text(
          text,
          style: textStyle,
        ),
      );
    });

    final scrollController = FixedExtentScrollController(
      initialItem: selected - 1,
    );

    final theme = AppTheme.of(context);

    return SafeArea(
      child: Column(
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, selected);
              },
            ),
          ),
          Container(
            height: 216.0,
            child: CupertinoPicker(
              scrollController: scrollController,
              onSelectedItemChanged: (n) => week = n + 1,
              children: items,
              backgroundColor: theme.backgroundColor,
              itemExtent: 32.0,
            ),
          )
        ],
      )
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
