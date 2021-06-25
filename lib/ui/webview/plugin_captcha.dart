import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

String get captchaNotify => '''
  (function () {
    setInterval(function() {
        var body = document.querySelector('body')
        if (body.textContent.indexOf('验证码发送失败') == -1) {
            return;
        }

        var alert = document.querySelector('.alert');
        if (alert.querySelector('h3')) {
            return;
        }

        var h3 = document.createElement("h3");
        h3.classList.add('h3');
        h3.innerHTML = '获取验证码需加入企业微信'

        var h4 = document.createElement("h4");
        h4.classList.add('h4');
        h4.innerHTML = '绑定企业微信方法：打开微信搜索“长春理工大学信息化中心”公众号，关注后点击“数字校园”->“加入企业微信”'

        alert.insertBefore(h4, alert.childNodes[0]);
        alert.insertBefore(h3, alert.childNodes[0]);
    }, 500);
  })()
  ''';

class PluginForCaptcha extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.path.startsWith('/cas/login');
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(captchaNotify);
  }
}