import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
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
    return Directory.current.path;
  }
}

const getDownloadDir = GetDownloadDir();