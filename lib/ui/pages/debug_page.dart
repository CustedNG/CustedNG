import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
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
    final content =
        permitted ? _buildTerminal(context) : _buildLockScreen(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.black,
          leading: BackIcon(),
          middle: NavbarText('Terminal')),
      child: content,
    );
  }

  Widget _buildLockScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              CupertinoTextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (otp) => otpInput = otp,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.inactiveGray.withAlpha(200),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CupertinoButton(
                child: Text('Unlock'),
                onPressed: () {
                  final otp = OTP.generateTOTPCode(
                    'ORXWC43UORXWC43U',
                    DateTime.now().millisecondsSinceEpoch,
                  );
                  if (otp.toString() == otpInput) {
                    setState(() {
                      permitted = true;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerminal(BuildContext context) {
    return SafeArea(
      child: _buildTerminalText(context),
    );
  }

  Widget _buildTerminalText(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: CupertinoColors.black,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'monospace',
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: debug.widgets,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
