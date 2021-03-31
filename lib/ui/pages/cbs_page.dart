import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/material.dart';

class CbsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(),
      body: PlaceholderWidget(text: 'Custed Backup Service'),
    );
  }
}
