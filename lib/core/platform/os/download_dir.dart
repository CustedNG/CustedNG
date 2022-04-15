import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:custed2/core/platform/platform_api.dart';
import 'package:path_provider/path_provider.dart';

class GetDownloadDir extends PlatformApi<Future<String>> {
  const GetDownloadDir();

  @override
  Future<String> andriod() async {
    return (await getTemporaryDirectory()).path;
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
