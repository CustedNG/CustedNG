import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchoolCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        middle: Text('校历', style: TextStyle(color: Colors.white)),
        trailing: [
          IconButton(
            onPressed: () => _showMenu(context),
            icon: Icon(Icons.file_download),
          )
        ],
      ),
      body: Center(
        child: DarkModeFilter(
          level: 160,
          child: ExtendedImage(
            height: MediaQuery.of(context).size.height,
            mode: ExtendedImageMode.gesture,
            fit: BoxFit.fitWidth,
            image: ImageRes.miscSchoolCalendar,
          ),
        )
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showRoundDialog(
        context,
        '保存到本地',
        Container(),
        [
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
        ]
    );
  }

  Future<void> save(BuildContext context) async {
    final bytes = await rootBundle.load(ImageRes.miscSchoolCalendar.assetName);
    saveImageToGallery(context, bytes.buffer.asUint8List());
  }
}
