import 'dart:io';
import 'dart:typed_data';

import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_save/image_save.dart';
import 'package:path/path.dart' show join;
import 'package:share_extend/share_extend.dart';

void saveImageToGallery(BuildContext context, Uint8List data) {
  if (Platform.isAndroid) return _saveAvatarInAndroid(data);
  return _saveAvatarGeneral(context, data);
}

void _saveAvatarInAndroid(Uint8List data) async {
  final path = join(await getAppDocDir.invoke(), "save.png");
  await File(path).writeAsBytes(data);
  ShareExtend.share(path, 'image');
}

void _saveAvatarGeneral(BuildContext context, Uint8List data) async {
  final year = DateTime.now().year;
  final ok = await ImageSave.saveImage(data, 'school_calendar_$year.png');
  final msg = ok ? '保存完成' : '保存失败';
  showSnackBar(context, msg);
}
