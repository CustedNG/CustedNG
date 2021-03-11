import 'dart:async';

import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_picker.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ScheduleWeekNavigator extends StatelessWidget {
  ScheduleWeekNavigator();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final hasSchedule = scheduleProvider.schedule != null;

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
          ConstrainedBox(
            constraints: BoxConstraints.tight(Size(45, 30)),
            child: Center(
                // intended to use PlaceHolder but it doesn't seem a placeholder
                child: Text(
              '${scheduleProvider.activeLessonCount} 节',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.lightTextColor,
              ),
              textAlign: TextAlign.center,
            )),
          ),
          // PlaceholderWidget(text: '${scheduleProvider.activeLessonCount} 节'),
          _ArrowButton(
              icon: CupertinoIcons.back,
              onPressed: scheduleProvider.gotoPrevWeek),
          _ArrowButton(
              icon: CupertinoIcons.forward,
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
    final theme = AppTheme.of(context);

    return GestureDetector(
      onLongPress: onLongPress,
      child: SizedBox(
        height: 35,
        width: 100,
        child: CupertinoButton(
          onPressed: onPressed,
          color: theme.scheduleButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          padding: EdgeInsets.zero,
          child: Text(
            text,
            style: TextStyle(
              color: theme.scheduleButtonTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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

    final week = await showCupertinoModalPopup(
      context: context,
      builder: (context) => ScheduleWeekPicker(
        currentWeek: scheduleProvider.currentWeek,
        selectedWeek: scheduleProvider.selectedWeek,
        maxWeek: scheduleProvider.maxWeek,
      ),
    );

    print('Week: $week');

    scheduleProvider.selectWeek(week);
  }
}

class _ArrowButton extends StatefulWidget {
  _ArrowButton({this.icon, this.onPressed});

  final IconData icon;
  final Function() onPressed;

  @override
  __ArrowButtonState createState() => __ArrowButtonState();
}

class __ArrowButtonState extends State<_ArrowButton> {
  Timer longPressTimer;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onLongPressStart: (_) => activateTimer(),
      onLongPressEnd: (_) => cancelTimer(),
      child: CupertinoButton(
        onPressed: widget.onPressed,
        padding: EdgeInsets.all(0),
        child: Icon(widget.icon, color: theme.scheduleTextColor),
      ),
    );
  }

  void activateTimer() {
    longPressTimer =
        Timer.periodic(Duration(milliseconds: 200), (_) => widget.onPressed());
  }

  void cancelTimer() => longPressTimer?.cancel();
}
