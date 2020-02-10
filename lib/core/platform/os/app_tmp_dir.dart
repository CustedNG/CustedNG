import 'dart:io';

import 'package:custed2/core/platform/platform_api.dart';
import 'package:path_provider/path_provider.dart';

class GetAppTmpDir extends PlatformApi<Future<String>> {
  const GetAppTmpDir();

  @override
  Future<String> andriod() async {
    final appDocDir = await getTemporaryDirectory();
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

const getAppTmpDir = GetAppTmpDir();