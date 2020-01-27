import 'dart:io';

import 'package:custed2/core/route.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/update/update_notice_page.dart';
import 'package:flutter/cupertino.dart';

updateCheck(BuildContext context, {bool force = false}) async {
  print('Checking for updates...');

  if (!Platform.isAndroid) {
    print('Update is only avaliable for andriod currently.');
    return;
  }

  final update = await locator<CustedService>().getUpdate();
  if (update == null) return;
  print('Update avaliable: $update');

  final settings = locator<SettingStore>();
  final ignore = settings.ignoreUpdate.fetch();
  if (!force && ignore != null && ignore >= update.build) {
    print('$ignore is skipped by user.');
    print('Update Skipped.');
    return;
  }

  if (!force && update.build <= BuildData.build) {
    print('Update build ${update.build}');
    print('However current build is ${BuildData.build}');
    print('Update Ignored.');
    return;
  }

  AppRoute(
    title: '更新',
    page: UpdateNoticePage(update),
  ).go(context, rootNavigator: true);
}
