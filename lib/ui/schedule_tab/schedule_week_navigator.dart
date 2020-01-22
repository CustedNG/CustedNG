import 'package:custed2/config/theme.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_picker.dart';
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
              () => _openPicker(context)),
          _buildArrowButton(
              context, CupertinoIcons.back, scheduleProvider.gotoPrevWeek),
          _buildArrowButton(
              context, CupertinoIcons.forward, scheduleProvider.gotoNextWeek),
        ],
      ),
    );
  }

  Widget _buildRoundButton(BuildContext context, String text, onPressed()) {
    final theme = AppTheme.of(context);

    return SizedBox(
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
    );
  }

  Widget _buildArrowButton(BuildContext context, IconData icon, onPressed()) {
    final theme = AppTheme.of(context);

    return CupertinoButton(
      child: Icon(
        icon,
        color: theme.scheduleTextColor,
      ),
      onPressed: onPressed, //this.incrWeek,
      padding: EdgeInsets.all(0),
    );
  }

  void _openPicker(BuildContext context) async {
    final scheduleProvider = locator<ScheduleProvider>();
    if (scheduleProvider.schedule == null) {
      return;
    }

    int week = scheduleProvider.selectedWeek;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => ScheduleWeekPicker(
        currentWeek: 1, // TODO: calculate current week
        selectedWeek: scheduleProvider.selectedWeek,
        maxWeek: scheduleProvider.maxWeek,
        onChange: (n) => week = n,
      ),
    );
    print('Week: $week');
    scheduleProvider.selectWeek(week);
  }
}
