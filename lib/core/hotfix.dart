import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:flutter/widgets.dart';

Future<void> doHotfix(BuildContext context) async {
  final hotfixes = await locator<CustedService>().getHotfix();
  final executer = locator<TTYExecuter>();
  for (var hotfix in hotfixes) {
    await executer.execute(hotfix, context, quiet: true);
  }
}
