import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:custed2/core/platform/platform_api.dart';

class GetDownloadDir extends PlatformApi<Future<String>> {
  const GetDownloadDir();

  @override
  Future<String> andriod() async {
    return AndroidPathProvider.downloadsPath;
  }

  @override
  Future<String> ios() {
    throw 'not supported in ios';
  }

  @override
  Future<String> fuchsia() async {
    final dir = path.join(Directory.current.path, './.custed/download');
    await Directory(dir).create(recursive: true);
    return dir;
  }
}

const getDownloadDir = GetDownloadDir();
