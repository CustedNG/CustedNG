import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleWeekPicker extends StatelessWidget {
  ScheduleWeekPicker({
    this.maxWeek,
    this.currentWeek,
    this.selectedWeek,
  });

  final int maxWeek;
  final int currentWeek;
  final int selectedWeek;

  @override
  Widget build(BuildContext context) {
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

    return Column(
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
            onSelectedItemChanged: (n) => selected = n + 1,
            children: items,
            backgroundColor: theme.backgroundColor,
            itemExtent: 32.0,
          ),
        )
      ],
    );
  }
}
