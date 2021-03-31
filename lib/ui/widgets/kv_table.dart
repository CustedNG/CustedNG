import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';

class KvTable extends StatelessWidget {
  KvTable(this.items);

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);
    final keyFont = TextStyle(
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black);

    final valueFont = TextStyle(
        fontWeight: FontWeight.normal,
        color: isDarkMode ? Colors.white : Colors.black);

    final lines = <Widget>[];

    for (var item in items.entries) {
      lines.add(Text(
        item.key,
        style: keyFont,
      ));
      lines.add(SizedBox(
        height: 2,
      ));
      lines.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          item.value,
          style: valueFont,
        ),
      ));
      lines.add(SizedBox(
        height: 15,
      ));
    }

    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: lines,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
