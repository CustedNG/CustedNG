import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleWeekPicker extends StatelessWidget {
  ScheduleWeekPicker({
    this.maxWeek,
    this.currentWeek,
    this.selectedWeek,
    this.onChange,
  });

  final int maxWeek;
  final int currentWeek;
  final int selectedWeek;
  final void Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    int selected = selectedWeek;
    final TextStyle textStyle = TextStyle(
        fontSize: 22.0,
        color: isDark(context) ? Colors.white : Colors.black
    );

    List<Widget> items = List<Widget>.generate(maxWeek, (i) {
      final String text =
          i + 1 == currentWeek ? '第${i + 1}周 - 当前周' : '第${i + 1}周';

      return Center(
        child: Text(
          text,
          style: textStyle,
        ),
      );
    });

    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: selectedWeek - 1);

    final theme = AppTheme.of(context);

    return Column(
      children: <Widget>[
        Flexible(
          child: GestureDetector(onTap: () {
            Navigator.pop(context, selected);
          }),
        ),
        Container(
          height: 216.0,
          child: CupertinoPicker(
            scrollController: scrollController,
            onSelectedItemChanged: (n) => onChange(n + 1),
            children: items,
            backgroundColor: theme.backgroundColor,
            itemExtent: 32.0,
          ),
        )
      ],
    );
  }
}
