import 'package:custed2/core/route.dart';
import 'package:custed2/ui/pages/cet_avatar_page.dart';
import 'package:custed2/ui/pages/debug_page.dart';
import 'package:custed2/ui/pages/empty_room_page.dart';
import 'package:custed2/ui/pages/exam_page.dart';
import 'package:custed2/ui/pages/map_page.dart';
import 'package:custed2/ui/pages/school_calendar_page.dart';
import 'package:custed2/ui/pages/tiku_page.dart';
import 'package:custed2/ui/user_tab/netdisk_page.dart';
import 'package:custed2/ui/webview/webview_browser.dart';

final custccBase = 'https://cust.cc';

// 因inappwebview问题 暂时使用旧版登录
// final loginPage = AppRoute(
//   title: '登录',
//   page: WebviewLogin(),
// page: LoginWebPage(),
// );

// 因webview, 提供传统登录方式
// final loginPageLegacy = AppRoute(
//   title: '登录(Legacy)',
//   page: LoginPageLegacy(),
// );

final debugPage = AppRoute(
  title: 'Terminal',
  page: DebugPage(),
);

final cetAvatarPage = AppRoute(
  title: '四六级照片',
  page: CetAvatarPage(),
);

final portalPage = AppRoute(
  title: '长理门户',
  page: WebviewBrowser('https://portal.cust.edu.cn'),
);

final tikuPage = AppRoute(
  title: '题库引导下载页面',
  page: TikuPage(),
);

final schoolCalendarPage = AppRoute(
  title: '校历',
  page: SchoolCalendarPage(),
);

final mapPage = AppRoute(
  title: '地图',
  page: MapPage(),
);

final netdiskPage = AppRoute(
  // title: '网盘与备份',
  title: '网盘',
  page: NetdiskPage(),
);

final netdiskWebPage = AppRoute(
  title: '长理网盘',
  page: WebviewBrowser('$custccBase/go/netdisk'),
);

// final feedbackPage =
//     AppRoute(title: '反馈', page: WebviewBrowser('$custccBase/go/feedback'));

final bbsPage =
    AppRoute(title: '校内导航', page: WebviewBrowser('https://bbs.cust.app'));

final custWikiPage =
    AppRoute(title: 'Cust Wiki', page: WebviewBrowser('https://cust.wiki'));

final emptyRoomPage = AppRoute(title: '空教室', page: EmptyRoomPage());

final selfWebPage = AppRoute(
  title: '校园网',
  //page: SelfWebPage(),
  page: WebviewBrowser('$custccBase/go/self'),
);

final ticeWebPage = AppRoute(
  title: '体测成绩',
  //page: TiceWebPage(),
  page: WebviewBrowser('$custccBase/go/tice'),
);

final examPage = AppRoute(
  title: '考试安排',
  page: ExamPage(),
);
