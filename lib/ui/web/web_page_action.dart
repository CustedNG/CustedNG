class WebPageAction {
  WebPageAction({this.name, this.handler});

  final String name;
  final void Function() handler;
}
