import 'package:custed2/ui/widgets/kv_table.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';

class KVTablePage extends StatelessWidget {
  final String title;
  final Map map;
  KVTablePage(this.title, this.map);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: NavbarText(title),
      ),
      body: SafeArea(
        child: KvTable(map),
      ),
    );
  }
}
