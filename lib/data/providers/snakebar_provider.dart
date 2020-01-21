import 'dart:async';

import 'package:custed2/core/provider/provider_base.dart';
import 'package:flutter/cupertino.dart';

class SnakebarProvider extends ProviderBase {
  static const kSnakebarDefaultHeight = 25;

  SnakebarProvider() {
    _contentQueue = StreamController<SnakeBarContent>();
    // add a placeholder
    _content = SnakeBarContent(
        widget: Container(),
        bgColor: CupertinoColors.activeBlue,
        duration: Duration.zero);
    _startLoop();
  }

  bool _isActive = false;
  SnakeBarContent _content;

  bool get isActive => _isActive;
  SnakeBarContent get content => _content;

  StreamController<SnakeBarContent> _contentQueue;
  int _index = 0;

  _startLoop() async {
    await for (var content in _contentQueue.stream) {
      _isActive = true;
      _content = content;
      notifyListeners();
      await Future.delayed(content.duration);
      _isActive = false;
      notifyListeners();
    }
  }

  add(
    Widget widget, {
    Color bgColor = CupertinoColors.activeBlue,
    Duration duration = const Duration(seconds: 3),
  }) {
    final content = SnakeBarContent(
      // set different keys to widget for AnimatedSwitcher to work.
      widget: KeyedSubtree(
        key: ValueKey(_index++),
        child: widget,
      ),
      bgColor: bgColor,
      duration: duration,
    );

    _contentQueue.sink.add(content);
  }

  info(String message) {
    add(Text(
      message,
      style: TextStyle(
        fontSize: 15,
        color: CupertinoColors.white,
      ),
    ));
  }

  clear() {
    _isActive = false;
    notifyListeners();
  }

  catchAll(func()) {
    Future.sync(func).catchError((e) => info('$e'));
  }
}

class SnakeBarContent {
  SnakeBarContent({
    this.widget,
    this.bgColor,
    this.duration,
  });

  Widget widget;
  Color bgColor;
  Duration duration;
}
