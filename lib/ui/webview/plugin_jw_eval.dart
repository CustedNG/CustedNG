import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';
import 'package:flutter/cupertino.dart';

const jwEvalHelper = '''

(function() {
  var body = document.querySelector('body')
  var container = document.createElement('div');
  body.appendChild(container);
  container.innerHTML = '评教助手';
  container.style.position = 'fixed';
  container.style.zIndex = 100;
  container.style.bottom = 20;
  container.style.left = 20;
  container.style.right = 20;
  container.style.backgroundColor = 'rgba(121, 187, 255, 0.2)';
  container.style.boxShadow = '0px 0px 5px #bbb;';
  container.style.display = 'none';

  function activate() {
    var evalPath = '/ClientStudent/EvaluateServices/StudentEvaluate'
    if (document.location.pathname == evalPath) {
      console.log('here1')
      container.style.display = 'block';
    } else {
      console.log('here2')
      container.style.display = 'none';
    }
  }

  setInterval(activate, 500);

})();

''';

class PluginJwEval extends Webview2Plugin{
  bool shouldActivate(Uri uri) {
    return uri.host.startsWith('jwgl');
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(jwEvalHelper);
  }
}

// class JwEvalWidget extends StatefulWidget {
//   JwEvalWidget(this.controller);

//   final Webview2Controller controller;

//   @override
//   _JwEvalWidgetState createState() => _JwEvalWidgetState();
// }

// class _JwEvalWidgetState extends State<JwEvalWidget> {
//   var busy = false;
//   var stop = false;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = busy
//         ? [
//             Text('评教中...'),
//             CupertinoButton(
//               child: Text('停止'),
//               onPressed: stopEvalAll,
//             ),
//           ]
//         : [
//             CupertinoButton(
//               child: Text('本页全选'),
//               onPressed: evalSelectAll,
//             ),
//             CupertinoButton(
//               child: Text('提交'),
//               onPressed: evalSubmit,
//             ),
//             CupertinoButton(
//               child: Text('下一个'),
//               onPressed: evalSwitchToNext,
//             ),
//             Text('/'),
//             CupertinoButton(
//               child: Text('一键评教'),
//               onPressed: evalAll,
//             ),
//           ];

//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: children,
//     );
//   }

//   Future<void> evalSelectAll([int grade]) async {
//     grade = grade ?? await getGrade();
//     if (grade == null) {
//       return;
//     }

//     final code = """
//       document.querySelectorAll('div[role=radiogroup]').forEach(e => {
//         e.querySelector('label:nth-child($grade)').click();
//       });
//     """;
//     return widget.controller.evalJavascript(code);
//   }

//   Future<void> evalSubmit() {
//     final code = r"""
//       document.querySelector('button.app-confirm.el-button--medium').click()
//     """;
//     return widget.controller.evalJavascript(code);
//   }

//   Future<bool> evalSwitchToNext() async {
//     final code = r"""
//       (function() {
//         for (e of document.querySelectorAll('li.el-select-dropdown__item')) {
//           if (e.innerText.includes('未评')) {
//             e.click();
//             return true;
//           }
//         }
//         alert('似乎评教已全部完成');
//         return false;
//       })();
//     """;
//     final result = await widget.controller.evalJavascript(code);
//     return result == 'true';
//   }

//   void evalAll() async {
//     final grade = await getGrade();
//     if (grade == null) {
//       return;
//     }

//     setState(() => busy = true);
//     while (await evalSwitchToNext()) {
//       if (stop == true) {
//         stop = false;
//         break;
//       }
//       await evalSelectAll(grade);
//       await Future.delayed(2.seconds);
//       await evalSubmit();
//       await Future.delayed(2.seconds);
//     }
//     setState(() => busy = false);
//   }

//   void stopEvalAll() {
//     stop = true;
//   }

//   Future<int> getGrade() {
//     return showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return JwEvalDialog();
//       },
//     );
//   }
// }

// class JwEvalDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoAlertDialog(
//       title: Text('选择评教成绩'),
//       // content: Text('请不要误伤值得好评的老师'),
//       actions: [
//         CupertinoDialogAction(
//           child: Text('优秀'),
//           onPressed: () => Navigator.of(context).pop(1),
//         ),
//         CupertinoDialogAction(
//           child: Text('良好'),
//           onPressed: () => Navigator.of(context).pop(2),
//         ),
//         CupertinoDialogAction(
//           child: Text('中等'),
//           onPressed: () => Navigator.of(context).pop(3),
//         ),
//         CupertinoDialogAction(
//           child: Text('较差'),
//           onPressed: () => Navigator.of(context).pop(4),
//         ),
//         CupertinoDialogAction(
//           child: Text('差'),
//           onPressed: () => Navigator.of(context).pop(5),
//         ),
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           child: Text('取消'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }
// }
