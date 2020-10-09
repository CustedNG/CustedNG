import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/kv_table.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage();

  @override
  Widget build(BuildContext context) {
    final version = BuildData.modifications != 0
        ? '${BuildData.build}(+${BuildData.modifications}f)'
        : '${BuildData.build}';

    return Scaffold(
      appBar: NavBar.material(
        context: context,
        leading: GestureDetector(
          child: BackIcon(),
          onTap: () => Navigator.pop(context),
        ),
        middle: NavbarText('关于'),
      ),
      body: SafeArea(
        child: KvTable({
          '名称': BuildData.name,
          '版本': version,
          'Engine': BuildData.engine,
          '构建日期': BuildData.buildAt,
        }),
      ),
    );
  }
}
