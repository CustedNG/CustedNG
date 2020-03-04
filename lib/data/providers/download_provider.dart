import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/locator.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart' as path;

class _DownloadTask {
  _DownloadTask({this.url, this.outputDir});

  String url;
  String outputDir;
}

class DownloadProvider extends ProviderBase {
  final queue = <_DownloadTask>[];

  Dio get dio =>
      Dio()..interceptors.add(CookieManager(locator<PersistCookieJar>()));

  _DownloadTask _currentTask;

  void enqueue(String url, String output) {
    queue.add(_DownloadTask(url: url, outputDir: output));
    _download();
  }

  void _download() async {
    if (_currentTask != null) return;
    if (queue.isEmpty) return;

    _currentTask = queue.removeLast();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempName = './custed_download_$timestamp.tmp';
    final tempOutputFile = path.join(_currentTask.outputDir, tempName);

    final snake = locator<SnakebarProvider>();
    await snake.progress((controller) async {
      controller.update(0, 1);
      final response = await dio.download(
        _currentTask.url,
        tempOutputFile,
        onReceiveProgress: controller.update,
      );
      final filenameHeader = response.headers.value('content-disposition');
      final filename = utf8.decode(percent.decode(
          RegExp(r'filename="(.+?)"').firstMatch(filenameHeader)?.group(1)));

      if (filename != null) {
        print(filename);
        final outputFile = path.join(_currentTask.outputDir, filename);
        await File(tempOutputFile).rename(outputFile);
        print(outputFile);
      }
      snake.info('"$filename" 下载完成');
      snake.info('已保存到系统 Download 文件夹下');
    });

    _currentTask = null;
  }

  void updateProgress(int current, int total) {}
}
