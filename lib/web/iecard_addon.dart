import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/service/iecard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class IecardAddon extends WebviewAddon {
  final _textEditingController = TextEditingController();

  double charge;

  bool shouldActivate(Uri uri) {
    return uri.toString().startsWith(IecardService.baseUrl);
  }

  Widget build(InAppWebViewController controller, String url) {
    return null;
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    //     Flexible(
    //       child: TextField(
    //         controller: _textEditingController,
    //         keyboardType: TextInputType.number,
    //       ),
    //     ),
    //     FlatButton(
    //       child: Text('快速充值'),
    //       onPressed: () async {
    //         await controller.loadUrl(url: IecardService.phoneChargeUrl);
    //         charge = double.tryParse(_textEditingController.value.text);
    //       },
    //     )
    //   ],
    // );
  }

  Future<void> onPageFinished(
      InAppWebViewController controller, String url) async {
    await controller.evaluateJavascript(source: '''
      (function() {
        // 首页下方导航
        var bottom = document.querySelector('.bottom-bar-pannel');
        if(bottom) bottom.parentNode.removeChild(bottom);

        // 首页上方导航
        var header = document.querySelector('.bill-header');
        if(header) header.parentNode.removeChild(header);

        // 圈存/改密码
        var content = document.querySelector('.content');
        if(content) content.style = '';

        // ??
        var space = document.querySelector('div[style="height:1.01rem;"]');
        if(space) space.parentNode.removeChild(space);
        
        // 流水查询
        var khfxWarp = document.querySelector('.khfxWarp');
        if(khfxWarp) khfxWarp.classList.remove('part-top03');

        // "应用中心"
        var bigHeader = document.querySelector('.custom_feture-header');
        if(bigHeader) bigHeader.parentNode.removeChild(bigHeader);
        
      })();
    ''');
  }
}
