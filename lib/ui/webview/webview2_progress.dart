import 'package:custed2/ui/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class Webview2Progress extends StatelessWidget {
  Webview2Progress({
    this.isLoading = false,
    this.progress = 0,
  });

  final bool isLoading;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isLoading,
      child: ProgressBar((progress * 100).ceil(), 100, bgColor: null),
    );
  }
}

// class Webview2Progress extends StatefulWidget with PreferredSizeWidget {
//   @override
//   _Webview2ProgressState createState() => _Webview2ProgressState();

//   @override
//   Size get preferredSize => CupertinoNavigationBar().preferredSize;
// }

// class _Webview2ProgressState extends State<Webview2Progress> {
//   @override
//   Widget build(BuildContext context) {
//     return Offstage(
//       offstage: !isLoading,
//       child: ProgressBar((progress * 100).ceil(), 100, bgColor: null),
//     );
//   }
// }
