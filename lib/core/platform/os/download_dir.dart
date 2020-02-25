import 'dart:io';

import 'package:custed2/core/platform/platform_api.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

class GetDownloadDir extends PlatformApi<Future<String>> {
  const GetDownloadDir();

  @override
  Future<String> andriod() async {
    final dir = await DownloadsPathProvider.downloadsDirectory;
    return dir.path;
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