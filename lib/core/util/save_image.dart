import 'dart:typed_data';

import 'package:custed2/core/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_save/image_save.dart';

void saveImageToGallery(BuildContext context, Uint8List data) async {
  final year = DateTime.now().year;
  final ok = await ImageSave.saveImage(data, 'school_calendar_$year.png');
  final msg = ok ? '保存完成' : '保存失败';
  showSnackBar(context, msg);
}
