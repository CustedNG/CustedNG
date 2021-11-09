import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:custed2/constants.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TikuPage extends StatelessWidget {
  const TikuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        middle: Text('题库'),
        context: context,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('题库App现已推出', style: TextStyle(fontSize: 27)),
            SizedBox(height: 20),
            Text('建议下载app使用\n当然你也可以继续使用网页版',
                style: TextStyle(color: Colors.grey, fontSize: 15),
                textAlign: TextAlign.center),
            SizedBox(height: 200),
            TextButton(
                onPressed: () async {
                  final tiku = await CustedService().getTikuUpdate();
                  if (tiku == null) {
                    showSnackBar(context, '暂时无法获取题库App下载链接');
                    return;
                  }
                  final url = Platform.isAndroid ? tiku.android : tiku.ios;
                  await FlutterClipboard.copy(url);
                  showSnackBar(context, '已复制题库App下载链接到剪贴板');
                  await openUrl(url);
                },
                child: Shimmer.fromColors(
                    child: Text('立即下载App'),
                    baseColor: Colors.blue,
                    highlightColor: Colors.redAccent)),
            Divider(),
            TextButton(
              onPressed: () => AppRoute(
                      page: WebviewBrowser(tikuUrl, showBottom: false),
                      title: '考试题库')
                  .go(context),
              child: Text('网页版'),
            )
          ],
        ),
      ),
    );
  }
}
