import 'package:after_layout/after_layout.dart';
import 'package:custed2/app_frame.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/pages/intro_page.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/setting_builder.dart';
import 'package:flutter/material.dart';

import 'data/store/user_data_store.dart';

bool _shouldEnableDarkMode(BuildContext context, int mode) {
  // print('ddf: ${MediaQuery.platformBrightnessOf(context)}');
  if (mode == DarkMode.on) return true;
  if (mode == DarkMode.off) return false;
  return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
}

class Custed extends StatefulWidget {
  @override
  _CustedState createState() => _CustedState();
}

class _CustedState extends State<Custed> with AfterLayoutMixin<Custed> {
  @override
  Widget build(BuildContext context) {
    final setting = locator<SettingStore>();
    bool haveInit = locator<UserDataStore>().haveInit.fetch();

    return SettingBuilder(
      setting: setting.darkMode,
      builder: (context, mode) {
        return MaterialApp(
          navigatorKey: locator<GlobalKey<NavigatorState>>(),
          title: 'Custed',
          home: AppFrame(),
          builder: (context, child) {
            bool isDarkMode = _shouldEnableDarkMode(context, mode);
            return Theme(
              data: ThemeData(
                brightness: isDarkMode ? Brightness.dark : Brightness.light,
              ),
              child: Builder(
                builder: (context) => DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText1,
                  child: child//haveInit
                      //? child
                      //: IntroScreen(
                      //isFromSetting: false,
                      //width: MediaQuery.of(context).size.width * 0.8
                  ),
              ),
            );
          },
        );
      },
    );
  }

  // 在这里进行初始化，避免启动掉帧
  @override
  void afterFirstLayout(BuildContext context) async {
    final path = await getAppDocDir.invoke();
    print('AppDocDir: $path');

    final debug = locator<DebugProvider>();
    debug.addMultiline(r'''
  
      _____         __         __   
     / ___/_ _____ / /____ ___/ /   
    / /__/ // (_-</ __/ -_) _  /    
    \___/\_,_/___/\__/\__/\_,_/     

      App First Layout Done. 
  
    ''');
  }
}
