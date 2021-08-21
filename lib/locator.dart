import 'package:alice/alice.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/banner_provider.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/download_provider.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/schedule_title_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/data/store/banner_store.dart';
import 'package:custed2/data/store/custom_lesson_store.dart';
import 'package:custed2/data/store/custom_schedule_store.dart';
import 'package:custed2/data/store/exam_store.dart';
import 'package:custed2/data/store/grade_store.dart';
import 'package:custed2/data/store/schedule_store.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/netdisk_service.dart';
import 'package:custed2/service/remote_config_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocatorForServices() {
  locator.registerLazySingleton(() => MyssoService());
  locator.registerLazySingleton(() => JwService());
  locator.registerLazySingleton(() => CustedService());
  locator.registerLazySingleton(() => NetdiskService());
  locator.registerLazySingleton(() => RemoteConfigService());
}

void setupLocatorForProviders() {
  locator.registerSingleton(SnakebarProvider());
  locator.registerSingleton(ScheduleProvider());
  locator.registerSingleton(ScheduleTitleProvider());
  locator.registerSingleton(GradeProvider());
  locator.registerSingleton(UserProvider());
  locator.registerSingleton(AppProvider());
  locator.registerSingleton(WeatherProvider());
  locator.registerSingleton(CetAvatarProvider());
  locator.registerSingleton(NetdiskProvider());
  locator.registerSingleton(DownloadProvider());
  locator.registerSingleton(BannerProvider());
  locator.registerSingleton(ExamProvider());
}

Future<void> setupLocatorForStores() async {
  final setting = SettingStore();
  await setting.init();
  locator.registerSingleton(setting);

  locator.registerSingletonAsync<UserDataStore>(() async {
    final store = UserDataStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<ScheduleStore>(() async {
    final store = ScheduleStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<CustomLessonStore>(() async {
    final store = CustomLessonStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<GradeStore>(() async {
    final store = GradeStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<BannerStore>(() async {
    final store = BannerStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<ExamStore>(() async {
    final store = ExamStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<CustomScheduleStore>(() async {
    final store = CustomScheduleStore();
    await store.init();
    return store;
  });
}

Future<void> setupLocator(String docDir) async {
  await setupLocatorForStores();

  setupLocatorForProviders();

  locator.registerLazySingleton(
    () => PersistCookieJar(storage: FileStorage('$docDir/.cookies/')),
  );

  locator.registerSingleton(GlobalKey<NavigatorState>());

  locator.registerLazySingleton(
    () => Alice(
      navigatorKey: locator<GlobalKey<NavigatorState>>(),
    ),
  );

  setupLocatorForServices();
}
