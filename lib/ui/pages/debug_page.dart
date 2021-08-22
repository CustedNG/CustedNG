import 'package:alice/alice.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String baseUrl = '';
  String otpInput = '';

  // bool permitted = buildMode == BuildMode.debug;
  bool permitted = true;

  DebugProvider get debug => Provider.of<DebugProvider>(context);

  @override
  Widget build(BuildContext context) {
    final content = _buildTerminal(context);

    return Scaffold(
      appBar: NavBar.material(
          context: context,
          middle: NavbarText('Terminal'),
          trailing: [
            TextButton(
              onPressed: () => AppRoute(
                      page: locator<Alice>().buildInspector(), title: 'alice')
                  .go(context),
              child: Text(''),
            )
          ],
          backgroundColor: Colors.black),
      body: content,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildTerminal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.black,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: debug.widgets,
          ),
        ),
      ),
    );
  }
}
