import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/core/platform/os/download_dir.dart';
import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/locator.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart' as path;
import 'package:share_extend/share_extend.dart';

class _DownloadTask {
  _DownloadTask({this.url});

  String url;
}

class DownloadProvider extends ProviderBase {
  final queue = <_DownloadTask>[];

  Dio get dio =>
      Dio()..interceptors.add(CookieManager(locator<PersistCookieJar>()));

  final behavior = _DownloadBehavior();

  _DownloadTask _currentTask;

  void enqueue(String url) {
    queue.add(_DownloadTask(url: url));
    _download();
  }

  void _download() async {
    if (_currentTask != null) return;
    if (queue.isEmpty) return;

    _currentTask = queue.removeLast();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempName = './custed_download_$timestamp.tmp';
    final tmepOutputDir = await behavior.getTempDir();
    final tempOutputFile = path.join(tmepOutputDir, tempName);

    final response = await dio.download(
      _currentTask.url,
      tempOutputFile,
    );
    final filenameHeader = response.headers.value('content-disposition');
    var filename = utf8.decode(percent.decode(
        RegExp(r'filename="(.+?)"').firstMatch(filenameHeader)?.group(1)));

    filename ??= tempName;
    behavior.saveFile(tempOutputFile, filename);

    _currentTask = null;
  }
}

abstract class _DownloadBehavior {
  factory _DownloadBehavior() {
    return Platform.isIOS ? _IOSBehavior() : _GeneralBehavior();
  }

  Future<String> getTempDir();
  void saveFile(String tempOutputFile, String filename);
}

class _GeneralBehavior implements _DownloadBehavior {
  Future<String> getTempDir() {
    return getDownloadDir.invoke();
  }

  void saveFile(String tempOutputFile, String filename) async {
    final outputDir = await getDownloadDir.invoke();
    final outputFile = path.join(outputDir, filename);
    await File(tempOutputFile).rename(outputFile);
  }
}

class _IOSBehavior implements _DownloadBehavior {
  Future<String> getTempDir() {
    return getAppDocDir.invoke();
  }

  void saveFile(String tempOutputFile, String filename) async {
    final outputFile = path.join(await getAppDocDir.invoke(), filename);
    await File(tempOutputFile).rename(outputFile);
    ShareExtend.share(outputFile, "file", sharePanelTitle: filename);
  }
}
