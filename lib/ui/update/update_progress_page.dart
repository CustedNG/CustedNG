import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: CupertinoColors.white,
      fontSize: 20,
      height: 1.3,
    );

    Widget content = Container(
      alignment: Alignment.center,
      color: Color(0xFF0078D7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(height: 40, width: 40, image: ImageRes.updateIndicator),
          SizedBox(height: 20),
          Text(msg),
          Text('${(progress * 100).ceil()}% 已完成'),
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

  @override
  void afterFirstLayout(BuildContext context) async {
    await init();
    await Future.delayed(Duration(milliseconds: 200));
    await download();
    await install();
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
    final docDir = await getAppDocDir.invoke();
    outputPath = path.join(docDir, './output.apk');
  }

  Future<void> download() async {
    updateMsg('正在准备更新');
    final url = CustedService.getUpdateUrl(widget.update);
    final total = widget.update.file.size * 1024;
    await Dio().download(url, outputPath, onReceiveProgress: (current, _) {
      setState(() => updateProgress(current / total));
    });
  }

  Future<void> install() async {
    updateMsg('正在安装');
    await InstallPlugin.installApk(outputPath, 'cc.xuty.custed2');
  }
}
