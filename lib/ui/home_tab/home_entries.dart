import 'package:custed2/config/routes.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/home_tab/home_entry.dart';
import 'package:flutter/cupertino.dart';

class HomeEntries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: 5,
      content: Table(children: [
        TableRow(children: [
          HomeEntry(
            name: Text('我的教务'),
            icon: Image(image: ImageRes.manageIcon),
            action: () => jwWebPage.go(context),
          ),
          HomeEntry(
            name: Text('一卡通'),
            icon: Image(image: ImageRes.ecardIcon),
            action: () => iecardWebPage.go(context),
          ),
          HomeEntry(
            name: Text('体测成绩'),
            icon: Image(image: ImageRes.runningReportIcon),
            // action: () => route.CustedRoute(
            //   title: '体测成绩',
            //   page: AppSite(
            //     url: 'https://app.cust.edu.cn/pe?isIOS=true',
            //     title: '体测成绩',
            //   ),
            // ).go(context),
          ),
          HomeEntry(
            name: Text('充网费'),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => ecardWebPage.go(context),
          ),
        ]),
        TableRow(children: [
          HomeEntry(
            name: Text('文档库'),
            icon: Image(image: ImageRes.rssIcon),
          ),
          HomeEntry(
            name: Text('考场查询'),
            icon: Image(image: ImageRes.mapIcon),
            action: () => examRoomWebPage.go(context),
          ),
          HomeEntry(
            name: Text('校园网'),
            icon: Image(image: ImageRes.networkIcon),
            // action: () => route.CustedRoute(
            //   title: '校园网',
            //   page: AppSite(
            //     url: 'https://app.cust.edu.cn/drcom?isIOS=true',
            //     title: '校园网',
            //   ),
            // ).go(context),
          ),
          HomeEntry(
            name: Text('快速联网'),
            icon: Image(image: ImageRes.wifiIcon),
            // action: () => route.wifiConnect.go(context),
          ),
        ])
      ]),
    );
  }
}
