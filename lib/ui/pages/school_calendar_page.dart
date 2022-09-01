import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            onPressed: () => _showMenu(context),
            icon: Icon(Icons.file_download),
          )
        ],
      ),
      body: Stack(
        children: [
          DarkModeFilter(
            level: 160,
            child: MyImage(cal.picUrl),
          ),
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
    showRoundDialog(context, cal.term, Text(cal.strSummary), [
      TextButton(
        child: Text('确定'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ]);
  }

  void _showMenu(BuildContext context) {
    showRoundDialog(context, '保存到本地', null, [
      TextButton(
        child: Text('确定'),
        onPressed: () {
          Navigator.of(context).pop();
          save(context);
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

  Future<void> save(BuildContext context) async {
    final bytes = await rootBundle.load(ImageRes.miscSchoolCalendar.assetName);
    saveImageToGallery(context, bytes.buffer.asUint8List());
  }
}
