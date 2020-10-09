import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/webview/addon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class JwEvalAddon extends WebviewAddon {
  bool shouldActivate(Uri uri) {
    return uri.path
        .startsWith('/ClientStudent/EvaluateServices/StudentEvaluate');
  }

  Widget build(InAppWebViewController controller, String url) {
    return JwEvalWidget(controller);
  }
}

class JwEvalWidget extends StatefulWidget {
  JwEvalWidget(this.controller);

  final InAppWebViewController controller;

  @override
  _JwEvalWidgetState createState() => _JwEvalWidgetState();
}

class _JwEvalWidgetState extends State<JwEvalWidget> {
  var busy = false;
  var stop = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = busy
        ? [
            Text('评教中...'),
            FlatButton(
              child: Text('停止'),
              onPressed: stopEvalAll,
            ),
          ]
        : [
            FlatButton(
              child: Text('本页全选'),
              onPressed: evalSelectAll,
            ),
            FlatButton(
              child: Text('提交'),
              onPressed: evalSubmit,
            ),
            FlatButton(
              child: Text('下一个'),
              onPressed: evalSwitchToNext,
            ),
            Text('/'),
            FlatButton(
              child: Text('一键评教'),
              onPressed: evalAll,
            ),
          ];

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Future<void> evalSelectAll([int grade]) async {
    grade = grade ?? await getGrade();
    if (grade == null) {
      return;
    }

    final code = """
      document.querySelectorAll('div[role=radiogroup]').forEach(e => {
        e.querySelector('label:nth-child($grade)').click();
      });
    """;
    return widget.controller.evaluateJavascript(source: code);
  }

  Future<void> evalSubmit() {
    final code = r"""
      document.querySelector('button.app-confirm.el-button--medium').click()
    """;
    return widget.controller.evaluateJavascript(source: code);
  }

  Future<bool> evalSwitchToNext() async {
    final code = r"""
      (function() {
        for (e of document.querySelectorAll('li.el-select-dropdown__item')) {
          if (e.innerText.includes('未评')) {
            e.click();
            return true;
          }
        }
        alert('似乎评教已全部完成');
        return false;
      })();
    """;
    final result = await widget.controller.evaluateJavascript(source: code);
    return result;
  }

  void evalAll() async {
    final grade = await getGrade();
    if (grade == null) {
      return;
    }

    setState(() => busy = true);
    while (await evalSwitchToNext()) {
      if (stop == true) {
        stop = false;
        break;
      }
      await evalSelectAll(grade);
      await Future.delayed(2.seconds);
      await evalSubmit();
      await Future.delayed(2.seconds);
    }
    setState(() => busy = false);
  }

  void stopEvalAll() {
    stop = true;
  }

  Future<int> getGrade() {
    return showDialog(
      context: context,
      builder: (context) {
        return JwEvalDialog();
      },
    );
  }
}

class JwEvalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('选择评教成绩'),
      // content: Text('请不要误伤值得好评的老师'),
      actions: [
        FlatButton(
          child: Text('优秀'),
          onPressed: () => Navigator.of(context).pop(1),
        ),
        FlatButton(
          child: Text('良好'),
          onPressed: () => Navigator.of(context).pop(2),
        ),
        FlatButton(
          child: Text('中等'),
          onPressed: () => Navigator.of(context).pop(3),
        ),
        FlatButton(
          child: Text('较差'),
          onPressed: () => Navigator.of(context).pop(4),
        ),
        FlatButton(
          child: Text('差'),
          onPressed: () => Navigator.of(context).pop(5),
        ),
        FlatButton(
          child: Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
