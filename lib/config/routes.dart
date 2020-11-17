import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/ui/home_tab/about_page.dart';
import 'package:custed2/ui/home_tab/home_go_to_wechat.dart';
import 'package:custed2/ui/pages/cbs_page.dart';
import 'package:custed2/ui/pages/cet_avatar_page.dart';
import 'package:custed2/ui/pages/debug_page.dart';
import 'package:custed2/ui/pages/exam_page.dart';
import 'package:custed2/ui/pages/login_page_legacy.dart';
import 'package:custed2/ui/pages/map_page.dart';
import 'package:custed2/ui/pages/school_calendar_page.dart';
import 'package:custed2/ui/user_tab/netdisk_page.dart';
import 'package:custed2/ui/web/custnav_web_page.dart';
import 'package:custed2/ui/web/ecard_web_page.dart';
import 'package:custed2/ui/web/exam_room_web_page.dart';
import 'package:custed2/ui/web/iecard_web_page.dart';
import 'package:custed2/ui/web/netdisk_web_page.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/webview/webview_login.dart';

// 因inappwebview问题 暂时使用旧版登录
final loginPage = AppRoute(
  title: '登录',
  page: WebviewLogin(),
  // page: LoginWebPage(),
);

// 因webview, 提供传统登录方式
final loginPageLegacy = AppRoute(
  title: '登录(Legacy)',
  page: LoginPageLegacy(),
);

final debugPage = AppRoute(
  title: 'Terminal',
  page: DebugPage(),
);

final cbsPage = AppRoute(
  title: 'CBS',
  page: CbsPage(),
);

final aboutPage = AppRoute(
  title: '关于',
  page: AboutPage(),
);

final cetAvatarPage = AppRoute(
  title: '四六级照片',
  page: CetAvatarPage(),
);

final jwWebPage = AppRoute(
  title: '教务系统',
  page: WebviewBrowser('https://cust.cc/go/jwgl'),
);

final iecardWebPage = AppRoute(
  title: '一卡通',
  page: IecardWebPage(),
);

final ecardWebPage = AppRoute(
  title: '充网费',
  page: EcardWebPage(),
);

final examRoomWebPage = AppRoute(
  title: '考场查询',
  page: ExamRoomWebPage(),
);

//final tikuWebPage = AppRoute(
//  title: '考试题库',
//  page: TikuWebPage(),
//);

final tiku2WebPage = AppRoute(
  title: '考试题库',
  //page: Tiku2WebPage(),
  page: WebviewBrowser('https://cust.cc/go/tiku'),
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
  page: NetdiskWebPage(),
  // page: WebviewBrowser('https://cust.cc/go/netdisk'),
);

final statusWebPage = AppRoute(
  title: '状态监测',
  //page: StatusWebPage(),
  page: WebviewBrowser('https://cust.cc/go/status'),
);

final selfWebPage = AppRoute(
  title: '校园网',
  //page: SelfWebPage(),
  page: WebviewBrowser('https://cust.cc/go/self'),
);

final ticeWebPage = AppRoute(
  title: '体测成绩',
  //page: TiceWebPage(),
  page: WebviewBrowser('https://cust.cc/go/tice'),
);

final custNavWebPage = AppRoute(
  title: 'Cust+',
  page: CustNavWebPage(),
);

final gotoWechat = AppRoute(
  title: '',
  page: GoToWechat(),
);

AppRoute examPage(JwExam exam) => AppRoute(
  title: '考试安排',
  page: ExamPage(exam: exam),
);