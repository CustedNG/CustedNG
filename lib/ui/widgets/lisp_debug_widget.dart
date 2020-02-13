import 'dart:io';

import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_ip/get_ip.dart';
import 'package:path/path.dart' as path;

class LispDebugWidget extends StatefulWidget {
  LispDebugWidget(this.interp);

  final LispInterp interp;

  @override
  _LispDebugWidgetState createState() => _LispDebugWidgetState();
}

class _LispDebugWidgetState extends State<LispDebugWidget> {
  HttpServer server;
  bool closed = false;

  @override
  void initState() {
    openServer();
    super.initState();
  }

  @override
  void dispose() {
    closeServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildStatus(context),
        if (!closed) _buildChild(context),
      ],
    );
  }

  Widget _buildStatus(BuildContext context) {
    final status = closed ? 'closed' : 'open';
    return Text('server is $status');
  }

  Widget _buildChild(BuildContext context) {
    return CupertinoButton(
      child: Text('关闭调试接口'),
      onPressed: () {
        closeServer();
      },
    );
  }

  Future<void> openServer() async {
    final addr = await GetIp.ipAddress;
    server = await HttpServer.bind(InternetAddress.anyIPv4, 2587);
    server.listen(onRequest);
    print('http://$addr:${server.port}/');
  }

  Future<void> closeServer() async {
    await server?.close();
    if (this.mounted) {
      setState(() => closed = true);
    }
    print('closed');
  }

  void onRequest(HttpRequest request) async {
    if (request.method == 'GET' && request.uri.path == '/') {
      return handleHome(request);
    }
    if (request.method == 'GET' && request.uri.path == '/eval') {
      return handleEval(request);
    }
    return handle404(request);
  }

  void handle404(HttpRequest request) async {
    request.response.write('-> nil');
    await request.response.close();
  }

  void handleHome(HttpRequest request) async {
    request.response.headers.contentType = ContentType.html;
    request.response.write(r'''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>CustedLispEngine</title>
</head>
<body>
    <form action="/eval" method="get">
        <textarea name="code" id="codeEditor" cols="30" rows="20"></textarea>
        <div><input type="checkbox" name="save" checked><label>Save?</label></div>
        <div><label>SaveAt:</label><input type="text" name="saveAt" value="test.cl"></div>
        <div><input type="submit" value="Eval"></div>
    </form>
</body>
</html>
    ''');
    await request.response.close();
  }

  void handleEval(HttpRequest request) async {
    final code = request.uri.queryParameters['code'] ?? '';

    final save = request.uri.queryParameters['save'] == 'on';
    final saveAt = request.uri.queryParameters['saveAt'] ?? 'unnamed.cl';
    final saveInfo = save ? 'save at: $saveAt' : 'unsaved';
    final saveFile = File(path.join(widget.interp.currentDir.path, saveAt));
    await saveFile.writeAsString(code);

    final addrInfo =
        '${request.connectionInfo.remoteAddress.address}:${request.connectionInfo.remotePort}';
    final debugInfo = '$addrInfo\n$saveInfo\n$code';
    locator<DebugProvider>().addMultiline(debugInfo, CupertinoColors.white);

    try {
      final result = await widget.interp.evalString(code, null);
      request.response.write('-> $result');
    } catch (e, stack) {
      request.response.write('-> $e\n');
      request.response.write('Stack:\n$stack');
    } finally {
      await request.response.close();
    }
  }
}
