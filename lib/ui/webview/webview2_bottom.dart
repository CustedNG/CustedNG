import 'package:custed2/core/open.dart';
import 'package:custed2/ui/widgets/missing_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class Webview2Bottom extends StatefulWidget{
  bool canBack = false;
  bool canForward = false;
  dynamic controller;

  Webview2Bottom(bool canBack, bool canForward, dynamic controller);

  @override
  State<StatefulWidget> createState() => _Webview2BottomState();
}

class _Webview2BottomState extends State<Webview2Bottom>{

  Future<String> evalJs(String source) async {
    var result = await widget.controller.evalJavascript(source);

    if (result.startsWith('"')) {
      result = result.substring(1);
    }

    if (result.endsWith('"')) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }

  Future<String> getUrl() {
    return evalJs('window.location.href');
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.1,
              color: CupertinoColors.opaqueSeparator.resolveFrom(context),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: widget.canBack
                    ? const Icon(Icons.arrow_back_ios)
                    : const Icon(Icons.arrow_back_ios, color: Colors.white54),
                onPressed: () async {
                  widget.controller?.goBack();
                }
            ),
            IconButton(
              icon: widget.canForward
                  ? const Icon(Icons.arrow_forward_ios)
                  : const Icon(Icons.arrow_forward_ios, color: Colors.white54),
              onPressed: () async {
                widget.controller?.goForward();
              } ,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                ShareExtend.share(await getUrl(), 'text');
              },
            ),
            IconButton(
              icon: const Icon(MissingIcons.earth, size: 26),
              onPressed: () async {
                openUrl(await getUrl());
              },
            ),
          ],
        ),
      ),
    );
  }

}