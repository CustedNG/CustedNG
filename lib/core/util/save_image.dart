import 'dart:io';
import 'dart:typed_data';

import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:save_in_gallery/save_in_gallery.dart';
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
  final ok = await ImageSaver().saveImage(imageBytes: data);
  final msg = ok ? '保存完成' : '保存失败';
  showSnackBar(context, msg);
}
