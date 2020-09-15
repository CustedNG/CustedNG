import 'package:custed2/service/iecard_service.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String get rmFooter => '''
    (function() {
      // 首页下方导航
      var bottom = document.querySelector('.bottom-bar-pannel');
      if(bottom) bottom.parentNode.removeChild(bottom);

      // 首页上方导航
      // var header = document.querySelector('.bill-header');
      // if(header) header.parentNode.removeChild(header);

      // 圈存/改密码
      // var content = document.querySelector('.content');
      // if(content) content.style = '';

      // ??
      // var space = document.querySelector('div[style="height:1.01rem;"]');
      // if(space) space.parentNode.removeChild(space);
      
      // 流水查询
      // var khfxWarp = document.querySelector('.khfxWarp');
      // if(khfxWarp) khfxWarp.classList.remove('part-top03');

      // "应用中心"
      // var bigHeader = document.querySelector('.custom_feture-header');
      // if(bigHeader) bigHeader.parentNode.removeChild(bigHeader);
      
    })();
  ''';

class PluginForIecard extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.toString().startsWith(IecardService.baseUrl);
  }

  @override
  void onPageFinished(FlutterWebviewPlugin webview, String url) async {
    webview.evalJavascript(rmFooter);
  }
}
