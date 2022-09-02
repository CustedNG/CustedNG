import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:flutter/material.dart';

class AddLessonWeeksPicker extends StatefulWidget {
  final Map<int, bool> data;
  AddLessonWeeksPicker(this.data, {Key key}) : super(key: key);
  _AddLessonWeeksPickerState createState() => _AddLessonWeeksPickerState();
}

class _AddLessonWeeksPickerState extends State<AddLessonWeeksPicker> {
  Map<int, bool> data;
  MediaQueryData _media;

  @override
  void initState() {
    data = Map.of(widget.data);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  Widget weekItem(int key, {bool active = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          data[key] = !data[key];
        });
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          key.toString(),
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              decoration: TextDecoration.none),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: active ? Color(0xFF529cf7) : null),
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
    final gridHeight = (_media.size.width - 4.0 * 6) / 5 / 2 * 5;
    return CardDialog(
      padding: EdgeInsets.symmetric(horizontal: 17),
      actions: [
        TextButton(
          child: Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.pop(context, data);
            }),
      ],
      content: SizedBox(
          height: gridHeight + 24 + 37,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 37,
              ),
              SizedBox(
                height: gridHeight - 24,
                width: 377,
                child: GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  gridDelegate: gridDelegate,
                  children: items,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    child: Text('单周'),
                    onPressed: () {
                      setState(() {
                        data.updateAll((key, value) => key % 2 == 0);
                      });
                    },
                  ),
                  TextButton(
                    child: Text('双周'),
                    onPressed: () {
                      setState(() {
                        data.updateAll((key, value) => key % 2 != 0);
                      });
                    },
                  ),
                  TextButton(
                    child: Text(allWeekSelected ? '全不选' : '全选'),
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
          )),
    );
  }
}
