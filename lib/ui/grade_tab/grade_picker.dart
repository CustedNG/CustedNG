import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradePicker extends StatelessWidget {
  GradePicker({this.currentIndex, this.terms});

  final int currentIndex;
  final List<String> terms;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = terms.map((term) {
      return Center(
        child: Text(
          term,
          style: TextStyle(
              color: isDark(context) ? Colors.white : Colors.black,
              fontSize: 22.0),
        ),
      );
    }).toList();

    final scrollController =
        FixedExtentScrollController(initialItem: currentIndex);

    final theme = AppTheme.of(context);

    return Column(
      children: <Widget>[
        Flexible(
          child: GestureDetector(onTap: () {
            Navigator.pop(context, scrollController.selectedItem);
          }),
        ),
        Container(
          height: 216.0,
          child: CupertinoPicker(
            scrollController: scrollController,
            onSelectedItemChanged: (_) {},
            children: items,
            backgroundColor: theme.backgroundColor,
            itemExtent: 40.0,
          ),
        )
      ],
    );
  }
}
