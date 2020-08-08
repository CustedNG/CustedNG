import 'package:flutter/widgets.dart';

class WebPageAction {
  WebPageAction({this.name, this.handler});

  final String name;
  final void Function(BuildContext context) handler;
}
