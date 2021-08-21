import 'dart:io';

import 'package:custed2/core/platform/platform_api.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class GetAppDocDir extends PlatformApi<Future<String>> {
  const GetAppDocDir();

  @override
  Future<String> andriod() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  @override
  Future<String> ios() {
    return andriod();
  }

  @override
  Future<String> fuchsia() async {
    final dir = path.join(Directory.current.path, './.custed');
    await Directory(dir).create(recursive: true);
    return dir;
  }
}

const getAppDocDir = GetAppDocDir();
