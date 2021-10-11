import 'dart:async';

import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/ui/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class SnakebarProvider extends ProviderBase {
  static const kSnakebarDefaultHeight = 25;
  static const kDefaultDuration = Duration(seconds: 3);

  SnakebarProvider() {
    _contentQueue = StreamController<SnakeBarContent>();
    // add a placeholder
    _content = SnakeBarContent(
      widget: SizedBox(),
      bgColor: Colors.blue,
    );
    _startLoop();
  }

  bool _isActive = false;
  SnakeBarContent _content;

  bool get isActive => _isActive;
  SnakeBarContent get content => _content;

  // ignore: close_sinks
  StreamController<SnakeBarContent> _contentQueue;
  int _index = 0;

  _startLoop() async {
    await for (var content in _contentQueue.stream) {
      _isActive = true;
      _content = content;
      notifyListeners();
      try {
        if (content.future != null) {
          await content.future;
        }
      } catch (e) {
        rethrow;
      } finally {
        _isActive = false;
        notifyListeners();
      }
    }
  }

  add(
    Widget widget, {
    Color bgColor = Colors.blue,
    Duration duration = kDefaultDuration,
  }) {
    final content = SnakeBarContent.duration(
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
        color: Colors.white,
      ),
    ));
  }

  warning(String message) {
    add(
      Text(
        message,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      bgColor: Colors.orange,
    );
  }

  Future progress(Future callback(SnakeBarProgressController controller)) {
    final widget = SnakeBarProgress();
    final future = callback(widget.controller);
    final content = SnakeBarContent(
      widget: widget,
      bgColor: Colors.blue,
      future: future,
    );
    _contentQueue.sink.add(content);
    return future;
  }

  clear() {
    _isActive = false;
    notifyListeners();
  }

  catchAll(func(), {String message, Duration duration = kDefaultDuration}) {
    Future.sync(func).catchError((e) => warning(message ?? '$e'));
  }
}

class SnakeBarContent {
  SnakeBarContent({
    this.widget,
    this.bgColor,
    Future future,
  }) : _future = future;

  SnakeBarContent.duration({
    this.widget,
    this.bgColor,
    Duration duration,
  }) : _duration = duration;

  Duration _duration;
  Future _future;

  Widget widget;
  Color bgColor;
  Future get future {
    if (_future != null) return _future;
    return Future.delayed(_duration);
  }
}

class SnakeBarProgress extends StatefulWidget {
  final controller = SnakeBarProgressController();

  @override
  _SnakeBarProgressState createState() => _SnakeBarProgressState();
}

class _SnakeBarProgressState extends State<SnakeBarProgress> {
  @override
  void initState() {
    widget.controller.addListener(onChange);
    super.initState();
  }

  void onChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      widget.controller.current,
      widget.controller.total,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(onChange);
    super.dispose();
  }
}

class SnakeBarProgressController extends ChangeNotifier {
  int current;
  int total;

  update(int current, int total) {
    this.current = current;
    this.total = total;
    notifyListeners();
  }
}
