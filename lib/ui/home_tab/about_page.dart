import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/widgets/kv_table.dart';
import 'package:flutter/cupertino.dart';

class AboutPage extends StatelessWidget {
  AboutPage();

  @override
  Widget build(BuildContext context) {
    final version = BuildData.modifications != 0
        ? '${BuildData.build}(+${BuildData.modifications}f)'
        : '${BuildData.build}';

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: SafeArea(
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
