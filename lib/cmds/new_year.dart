import 'package:custed2/core/tty/command.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/locator.dart';

class NewYearCommand extends TTYCommand {
  @override
  final name = 'newyear';

  @override
  final help = 'Happy new year.';

  @override
  final alias = 'ny';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) async {
    final ss = [
      '鼠年来到掷臂高呼 如意花开美满幸福',
      '太平盛世长命百岁 身体健康光明前途',
      '一帆风顺一生富裕 事业辉煌心畅情舒',
      '步步高升财源广进 家庭美满和谐共处',
      '祝你鼠年开门大吉！',
    ];
    for (var s in ss) {
      locator<SnakebarProvider>().info(s);
    }
  }
}
