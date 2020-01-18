import 'package:flutter/cupertino.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}