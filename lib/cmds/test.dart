import 'package:custed2/core/tty/command.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class TestCommand extends TTYCommand {
  @override
  final name = 'test';

  @override
  final help = 'No guaranty what happens.';

  @override
  final alias = 't';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) async {
    // print(await locator<MyssoService>().login());
    // print(await locator<MyssoApi>().getTicket('http://192.168.223.72:8080/welcome'));

    // mysso -> TGC
    // webvpn -> TWFID
    // sys8 -> ASP.NET_SessionId
    // print(await locator<Sys8Api>().home());
    // WebvpnService
    // print(await locator<WebvpnService>().login());
    // print(await locator<WebvpnApi>().home());
    // final schedule = await locator<Sys8Service>().getSchedule();
    // locator<DebugProvider>().addMultiline(schedule.toString());

    // print(await MyssoService().getTicketForPortal());
    // print(await MyssoService().getTicketForWebvpn());

    // print(await JwService().getSchedule());
    // print(await JwService().getWeekTime());
    // print(await JwService().isSessionExpired(null));
    // print(await JwService().isSessionExpired(await JwService().get('http://qq.com')));
    // print(await IecardService().login());

    print(await MyssoService().getTicketForJw());
  }
}
