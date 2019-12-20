import 'package:custed2/ui/frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(Custed());

class Custed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const isDark = false;
    
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      
      title: 'Custed',
      home: AppFrame(),
    );
  }
}
