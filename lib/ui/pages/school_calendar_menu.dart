import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/res/image_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SchoolCalendarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('保存到本地'),
      actions: <Widget>[
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
      ],
    );
  }

  Future<void> save(BuildContext context) async {
    final bytes = await rootBundle.load(ImageRes.miscSchoolCalendar.assetName);
    saveImageToGallery(context, bytes.buffer.asUint8List());
  }
}
