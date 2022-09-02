import 'dart:typed_data';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/zoomable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SchoolCalendarPage extends StatefulWidget {
  @override
  _SchoolCalendarPageState createState() => _SchoolCalendarPageState();
}

class _SchoolCalendarPageState extends State<SchoolCalendarPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cal = locator<AppProvider>().cal;
    if (cal == null) {
      return Scaffold(
        appBar: NavBar.material(
          context: context,
          middle: Text('校历'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: Text('校历'),
        trailing: [
          IconButton(
            onPressed: () => _showMenu(context, cal.picUrl),
            icon: Icon(Icons.file_download),
          )
        ],
      ),
      body: Stack(
        children: [
          Expanded(child: DarkModeFilter(
            level: 160,
            child: ZoomableWidget(child: MyImage(cal.picUrl), maxScale: 5.7, minScale: 1,),
          )),
          Positioned(
            child: Container(
              height: 47,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black38, Colors.transparent],
                      begin: FractionalOffset(0.5, 0),
                      end: FractionalOffset(0.5, 1))),
              width: size.width,
            ),
          ),
          Positioned(
            top: 10,
            child: Center(
                widthFactor: 1.0,
                child: GestureDetector(
                  child: Container(
                    width: size.width,
                    child: Text('点击查看文字版',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
                  ),
                  onTap: () => _showViewCalendarDialog(cal),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _showViewCalendarDialog(CustedConfigSchoolCalendar cal) async {
    showRoundDialog(context, cal.term, Text(cal.strSummary.isEmpty ? '抱歉，暂无文字版' : cal.strSummary), [
      TextButton(
        child: Text('确定'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ]);
  }

  void _showMenu(BuildContext context, String picUrl) {
    showRoundDialog(context, '保存到本地', null, [
      TextButton(
        child: Text('确定'),
        onPressed: () async {
          Navigator.of(context).pop();
          await save(context, (await Client().get(picUrl.uri)).bodyBytes);
        },
      ),
      TextButton(
        child: Text('取消'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ]);
  }

  Future<void> save(BuildContext context, Uint8List data) async {
    saveImageToGallery(context, data);
  }
}
