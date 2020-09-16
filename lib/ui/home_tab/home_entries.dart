import 'package:custed2/config/routes.dart';
import 'package:custed2/core/script.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/home_tab/home_entry.dart';
import 'package:custed2/ui/home_tab/home_open_iecard.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeEntries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return HomeCard(
      padding: 5,
      content: Table(children: [
        TableRow(children: [
          HomeEntry(
            name: Text('我的教务'),
            icon: Image(image: ImageRes.manageIcon),
            action: () => jwWebPage.popup(context),
          ),
          HomeEntry(
            name: Text('一卡通'),
            icon: Image(image: ImageRes.ecardIcon),
            // action: () => iecardWebPage.go(context),
            // action: () => openIecard(context),
            action: () => gotoWechat.go(context),
            longPressAction: () => openIecard(context),
          ),
          HomeEntry(
            name: Text('体测成绩'),
            icon: Image(image: ImageRes.runningReportIcon),
            // action: () => runScript('sport_grade.cl', context),
            action: () => ticeWebPage.popup(context),
          ),
          HomeEntry(
            name: Text('充网费'),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => ecardWebPage.go(context),
            action: () => gotoWechat.go(context),
            longPressAction: () => ecardWebPage.go(context),
          ),
        ]),
        TableRow(children: [
          HomeEntry(
            name: Text('题库'),
            icon: Image(image: ImageRes.tikuIcon),
            action: () => tiku2WebPage.popup(context),
          ),
          HomeEntry(
            // name: Text('考场查询'),
            name: Text('导航'),
            icon: Image(image: ImageRes.mapIcon),
            // action: () => examRoomWebPage.go(context),
            // action: () => custNavWebPage.go(context),
            action: () => appProvider.setTab(AppProvider.navTab),
          ),
          HomeEntry(
            name: Text('校园网'),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => runScript('network_manage.cl', context),
            action: () => selfWebPage.popup(context),
          ),
          HomeEntry(
            name: Text('快速联网'),
            icon: Image(image: ImageRes.wifiIcon),
            action: () => runScript('wifi_connect.cl', context),
          ),
        ])
      ]),
    );
  }
}
