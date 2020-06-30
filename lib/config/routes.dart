import 'package:custed2/core/route.dart';
import 'package:custed2/ui/home_tab/about_page.dart';
import 'package:custed2/ui/pages/cbs_page.dart';
import 'package:custed2/ui/pages/cet_avatar_page.dart';
import 'package:custed2/ui/pages/debug_page.dart';
import 'package:custed2/ui/pages/login_page.dart';
import 'package:custed2/ui/pages/login_page_legacy.dart';
import 'package:custed2/ui/pages/school_calendar_page.dart';
import 'package:custed2/ui/user_tab/dark_mode.dart';
import 'package:custed2/ui/user_tab/netdisk_page.dart';
import 'package:custed2/ui/web/ecard_web_page.dart';
import 'package:custed2/ui/web/exam_room_web_page.dart';
import 'package:custed2/ui/web/iecard_web_page.dart';
import 'package:custed2/ui/web/jw_web_page.dart';
import 'package:custed2/ui/web/login_web_page.dart';
import 'package:custed2/ui/web/netdisk_web_page.dart';
import 'package:custed2/ui/web/status_web_page.dart';
import 'package:custed2/ui/web/tiku2_web_page.dart';
import 'package:custed2/ui/web/tiku_web_page.dart';

final loginWebPage = AppRoute(
  title: '登录',
  page: LoginWebPage(),
);

// 因inappwebview问题 暂时使用旧版登录
final loginPage = AppRoute(
  title: '登录',
  page: LoginPage(),
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
  page: JwWebPage(),
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

final tikuWebPage = AppRoute(
  title: '考试题库',
  page: TikuWebPage(),
);

final tiku2WebPage = AppRoute(
  title: '考试题库',
  page: Tiku2WebPage(),
);

final schoolCalendarPage = AppRoute(
  title: '校历',
  page: SchoolCalendarPage(),
);

final netdiskPage = AppRoute(
  // title: '网盘与备份',
  title: '网盘',
  page: NetdiskPage(),
);

final netdiskWebPage = AppRoute(
  title: '长理网盘',
  page: NetdiskWebPage(),
);

final statusWebPage = AppRoute(
  title: '状态监测',
  page: StatusWebPage(),
);

final darkModePage = AppRoute(
  title: '黑暗模式',
  page: DarkModePage(),
);
