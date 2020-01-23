import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/store/schedule_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/cas_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class Test2Command extends TTYCommand {
  @override
  final name = 'test2';

  @override
  final help = 'No guaranty what happens, again.';

  @override
  final alias = 'tt';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) async {
    final schedule = locator<ScheduleProvider>();
    print('Current week: ${schedule.currentWeek}');
  }
}