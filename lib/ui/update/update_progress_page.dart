import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:crypto/crypto.dart';
import 'package:custed2/core/platform/os/app_tmp_dir.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:install_plugin/install_plugin.dart';
import 'package:path/path.dart' as path;

class UpdateProgressPage extends StatefulWidget {
  UpdateProgressPage(this.update);

  final CustedUpdate update;

  @override
  _UpdateProgressPageState createState() => _UpdateProgressPageState();
}

class _UpdateProgressPageState extends State<UpdateProgressPage>
    with AfterLayoutMixin<UpdateProgressPage> {
  String msg = '更新中';
  String outputPath;
  double progress = 0.0;
  bool failed = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: CupertinoColors.white,
      fontSize: 20,
      height: 1.3,
    );

    final image = failed
        ? Icon(Icons.error_outline, size: 40, color: CupertinoColors.white)
        : Image(height: 40, width: 40, image: ImageRes.updateIndicator);

    final message = failed
        ? _buildRetryButton(context)
        : Text('${(progress * 100).ceil()}% 已完成');

    Widget content = Container(
      alignment: Alignment.center,
      color: Color(0xFF0078D7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          image,
          SizedBox(height: 20),
          Text(msg),
          message,
        ],
      ),
    );

    content = DefaultTextStyle(
      style: textStyle,
      child: content,
    );

    return WillPopScope(
      onWillPop: () async {
        locator<SnakebarProvider>().info('更新将在后台进行');
        return true;
      },
      child: content,
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    final retryText = Text(
      '重试',
      style: TextStyle(
        color: CupertinoColors.white,
        decoration: TextDecoration.underline,
      ),
    );

    return CupertinoButton(
      child: retryText,
      onPressed: doUpdate,
      padding: EdgeInsets.zero,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    doUpdate();
  }

  void doUpdate() async {
    try {
      await init();
      await Future.delayed(Duration(milliseconds: 200));
      await download();
      await verify();
      await install();
    } on UpdateException catch (e) {
      updateMsg(e.message);
      setState(() => failed = true);
      rethrow;
    } catch (e) {
      updateMsg('出现未知错误');
      setState(() => failed = true);
      rethrow;
    }
  }

  void updateMsg(String msg) {
    if (!mounted) return;
    setState(() => this.msg = msg);
  }

  void updateProgress(double progress) {
    if (!mounted) return;
    setState(() => this.progress = progress);
  }

  Future<void> init() async {
    updateMsg('正在初始化');
    setState(() => failed = false);
    setState(() => updateProgress(0.0));

    final docDir = await getAppTmpDir.invoke();
    outputPath = path.join(docDir, './output.apk');
  }

  Future<void> download() async {
    updateMsg('正在准备更新');
    final url = CustedService.getUpdateUrl(widget.update);
    final total = widget.update.file.size * 1024;
    await Dio().download(url, outputPath, onReceiveProgress: (current, _) {
      if (!mounted) return;
      setState(() => updateProgress(current / total));
    });
  }

  Future<void> verify() async {
    updateMsg('正在校验');

    setState(() => updateProgress(0.25));
    final exists = await File(outputPath).exists();
    if (!exists) {
      throw UpdateException('校验失败[1]');
    }

    setState(() => updateProgress(0.50));
    final hash = base64.decode(base64.normalize(widget.update.file.sha256));
    final computed = await sha256.bind(File(outputPath).openRead()).first;
    if (compareHash(hash, computed.bytes)) {
      throw UpdateException('校验失败[2]');
    }

    setState(() => updateProgress(1.0));
  }

  Future<void> install() async {
    updateMsg('正在安装');
    await Future.delayed(Duration(milliseconds: 500));
    await InstallPlugin.installApk(outputPath, 'cc.xuty.custed2');
  }
}

class UpdateException implements Exception {
  UpdateException(this.message);

  final String message;

  @override
  String toString() => 'UpdateException: $message';
}

bool compareHash(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
