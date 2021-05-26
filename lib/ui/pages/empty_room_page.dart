import 'package:custed2/core/utils.dart';
import 'package:custed2/data/models/jw_empty_room/jw_empty_room.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_field.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';

class EmptyRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmptyRoomPageState();
}

class _EmptyRoomPageState extends State<EmptyRoomPage> {
  final now = DateTime.now();
  String dateStr = '';
  int selectedSection = 0;
  String selectedBuildingKey = '西1教';
  List<String> sections = ['1-2', '3-4', '5-6', '7-8', '9-10', '11-12'];
  Map<String, String> buildingIDs = {
    '西1教': 'f74dac26-c58a-4eae-bc46-ff2055b2de19',
    '西2教': '201a429b-df6d-489e-9a1d-de7c85f0081e',
    '西图书馆': '3adb80f2-7e27-4058-a60c-fbb32cb36587',
    '东1教': 'd91cc53c-a9ad-4be3-becf-7f3ed62e8762',
    '东2教': 'e14b90bd-0c92-422e-b299-7009118104b9',
    '东3教': '3534f8ce-f10b-4058-a818-95a116d9bca4',
    '东前楼': '6accca4d-b092-4bdc-b2e0-0c1941782eec',
    '南研': '20a207f7-65ef-4ae4-9286-2a2b5a73e1c9',
    '南实训': 'cb5265e8-84a1-41ed-985b-3920449738aa'
  };
  final dayController = TextEditingController();
  final sectionController = TextEditingController();
  final buildingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateStr = now.toString().substring(0, 10);
    dayController.text = dateStr;
    sectionController.text = sections[selectedSection];
    buildingController.text = selectedBuildingKey;
  }

  String fitLength(String raw) {
    return '${raw.length == 1 ? 0 : ""}${raw}';
  }

  Widget _buildEmptyRoomList(JwEmptyRoom data) {
    List<Widget> children = [];
    for (var item in data.data.pagingResult.rows) {
      children.add(Center(child: Text(item.jsmc)));
    }
    return ListView(
      shrinkWrap: true,
      children: children,
    );
  }

  Future<void> getData() async {
    final sectionSplit = sections[selectedSection].split('-');


    final result = await JwService().getEmptyRoom(
        dateStr,
        ['${fitLength(sectionSplit[0])}${fitLength(sectionSplit[1])}'],
        buildingIDs[selectedBuildingKey]);
    if (result.state == 0) {
      showRoundDialog(
        context, 
        '结果', 
        _buildEmptyRoomList(result), 
        [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), child: Text('关闭'))
        ]
      );
    } else {
      showSnackBar(context, result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        middle: NavbarText('空教室'),
        trailing: [
          IconButton(
            onPressed: () => getData(), 
            icon: Icon(Icons.search)
          )
        ]
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          AddLessonField(
            Icons.date_range,
            isReadonly: true,
            placeholder: '日期',
            controller: dayController,
            onTap: () => _showDatePicker(),
          ),
          AddLessonField(
            Icons.list,
            isReadonly: true,
            placeholder: '节数',
            controller: sectionController,
            onTap: () => _showSectionPicker(),
          ),
          AddLessonField(
            Icons.architecture,
            isReadonly: true,
            placeholder: '教学楼',
            controller: buildingController,
            onTap: () => _showBuildingPicker(),
          )
        ],
      ),
    );
  }

  void _showBuildingPicker() async {
    await showRoundDialog(
        context,
        '选择教学楼',
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.black12,
                ),
              ),
              top: 55,
              bottom: 55,
              left: 0,
              right: 0,
            ),
            Container(
              height: 150.0,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 37,
                diameterRatio: 1.2,
                onSelectedItemChanged: (n) => setState(() {
                  selectedBuildingKey = buildingIDs.keys.elementAt(n);
                }),
                controller: FixedExtentScrollController(
                    initialItem:
                        buildingIDs.keys.toList().indexOf(selectedBuildingKey)),
                physics: FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) =>
                        Center(child: Text(buildingIDs.keys.elementAt(index))),
                    childCount: buildingIDs.keys.length),
              ),
            ),
          ],
        ),
        null);
  }

  void _showSectionPicker() async {
    await showRoundDialog(
        context,
        '选择节数',
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.black12,
                ),
              ),
              top: 55,
              bottom: 55,
              left: 0,
              right: 0,
            ),
            Container(
              height: 150.0,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 37,
                diameterRatio: 1.2,
                onSelectedItemChanged: (n) => setState(() {
                  selectedSection = n;
                }),
                controller:
                    FixedExtentScrollController(initialItem: selectedSection),
                physics: FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) =>
                        Center(child: Text(sections[index] + '节')),
                    childCount: sections.length),
              ),
            ),
          ],
        ),
        null);
  }

  void _showDatePicker() async {
    final result = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(Duration(days: 15)),
        locale: Locale('zh'));
    setState(() {
      if (result != null) {
        dateStr = result.toString().substring(0, 10);
      }
    });
  }
}
