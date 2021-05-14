import 'dart:io';

abstract class Webview2Controller {
  Future<String> evalJavascript(String source);

  Future<void> injectCss(String source) {
    source = source.split('\n').join(r'\n');
    return evalJavascript('''
      (function () {
        var node = document.createElement('style');
        node.innerHTML = '$source';
        console.log(node);
        document.getElementsByTagName("head")[0].appendChild(node);
      })();
    ''');
  }

  Future<void> clearCookies();

  Future<List<Cookie>> getCookies(String url);

  Future<void> setCookies(List<Cookie> cookies);

  Future<void> loadUrl(String url);

  Future<void> close();
}
