import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/res/image_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class SchoolCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('校历', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showMenu(context),
            icon: Icon(Icons.file_download),
          )
        ],
      ),
      body: ClipRect(
        child: SafeArea(
          child: DarkModeFilter(
            level: 160,
            child: PhotoView(
              maxScale: 1.0,
              minScale: 0.1,
              imageProvider: ImageRes.miscSchoolCalendar,
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showRoundDialog(
        context,
        '保存到本地',
        Container(),
        [
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
              save(context);
            },
          ),
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]
    );
  }

  Future<void> save(BuildContext context) async {
    final bytes = await rootBundle.load(ImageRes.miscSchoolCalendar.assetName);
    saveImageToGallery(context, bytes.buffer.asUint8List());
  }
}
