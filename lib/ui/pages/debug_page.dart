import 'package:alice/alice.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
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

    return Scaffold(
      appBar: NavBar.material(
          middle: NavbarText('Terminal'),
          trailing: [IconButton(
            icon: Icon(Icons.network_cell), 
            onPressed: () => AppRoute(
              page: locator<Alice>().buildInspector(),
              title: 'alice'
            ).go(context)
          )],
          backgroundColor: Colors.black
        ),
      body: content,
      backgroundColor: Colors.black,
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
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (otp) => otpInput = otp,
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
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
