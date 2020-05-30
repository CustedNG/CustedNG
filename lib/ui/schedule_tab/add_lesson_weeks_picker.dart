import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class AddLessonWeeksPicker extends StatefulWidget {
  final Map<int, bool> data;
  AddLessonWeeksPicker(this.data, {Key key}) : super(key: key);
  _AddLessonWeeksPickerState createState() => _AddLessonWeeksPickerState();
}

class _AddLessonWeeksPickerState extends State<AddLessonWeeksPicker> {
  Map<int, bool> data;

  @override
  void initState() {
    data = Map.of(widget.data);
    super.initState();
  }

  Widget weekItem(int key, {bool active = false}) {
    final theme = AppTheme.of(context);
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          data[key] = !data[key];
        });
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              key.toString(),
              style: TextStyle(
                  fontSize: 15.0,
                  color: active && !isDark
                      ? theme.textColorInversed
                      : theme.textColor),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: active ? Color(0xFF529cf7) : null),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              CupertinoIcons.check_mark_circled,
              color: active ? CupertinoColors.white : Colors.transparent,
              size: 23.0,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = data.entries.map(
      (entry) {
        return Container(
          child: weekItem(
            entry.key,
            active: entry.value,
          ),
        );
      },
    ).toList();
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      childAspectRatio: 2,
    );
    final allWeekSelected = data.values.every((week) => week == true);
    final theme = AppTheme.of(context);
    return SafeArea(
      bottom: false,
      child: Container(
        color: theme.textFieldListBackgroundColor,
        height: (MediaQuery.of(context).size.width - 4.0 * 6) / 5 / 2 * 5 +
            4.0 * 6 +
            60.0 +
            60.0,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60.0,
              alignment: Alignment.center,
              child: CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                padding: EdgeInsetsDirectional.zero,
                leading: NavBarButton(
                  child: Align(alignment: Alignment.center, child: Text("取消")),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                middle: Text(
                  "选择上课周数",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                trailing: NavBarButton(
                    child:
                        Align(alignment: Alignment.center, child: Text("确定")),
                    onPressed: () {
                      Navigator.pop(context, data);
                    }),
                backgroundColor: theme.textFieldListBackgroundColor,
              ),
            ),
            GridView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              gridDelegate: gridDelegate,
              children: items,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CupertinoButton(
                  child: Text("单周"),
                  onPressed: () {
                    setState(() {
                      data.updateAll((key, value) => key % 2 == 0);
                    });
                  },
                ),
                CupertinoButton(
                  child: Text("双周"),
                  onPressed: () {
                    setState(() {
                      data.updateAll((key, value) => key % 2 != 0);
                    });
                  },
                ),
                CupertinoButton(
                  child: Text(allWeekSelected ? "全不选" : "全选"),
                  onPressed: () {
                    setState(() {
                      final newValue = allWeekSelected ? false : true;
                      data.updateAll((key, value) => newValue);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
