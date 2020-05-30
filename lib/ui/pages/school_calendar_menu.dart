import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/res/image_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

class SchoolCalendarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('保存到本地'),
          onPressed: () {
            Navigator.of(context).pop();
            save();
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('取消'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> save() async {
    final bytes = await rootBundle.load(ImageRes.miscSchoolCalendar.assetName);
    saveImageToGallery(bytes.buffer.asUint8List());
  }
}
