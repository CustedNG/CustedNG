import 'dart:io';

import 'package:custed2/platform/platform_api.dart';
import 'package:path_provider/path_provider.dart';

class AppDocDir extends PlatformApi<Future<String>> {
  const AppDocDir();

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
    return Directory.current.path;
  }
}

const getAppDocDir = AppDocDir();