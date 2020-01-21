import 'package:custed2/config/theme.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';

class ScheduleWeekSelector extends StatelessWidget {
  ScheduleWeekSelector();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final scheduleProvider = locator<ScheduleProvider>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.scheduleOutlineColor,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildRoundButton(context, '第一周', () {}),
          _buildArrowButton(context, CupertinoIcons.back, () {}),
          _buildArrowButton(context, CupertinoIcons.forward, () {}),
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
}
