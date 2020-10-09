import 'dart:io';

import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/update/update_notice_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

updateCheck(BuildContext context, {bool force = false}) async {
  print('Checking for updates...');

  // if (BuildMode.isDebug) {
  //   print('Now in debug mode, skip checking updates.');
  //   return;
  // }

  if (Platform.isAndroid) {
    doAndroidUpdate(context, force: force);
    return;
  }

  if (Platform.isIOS) {
    doTestflightUpdate(context, force: force);
    return;
  }
}

Future<bool> isFileAvaliable(String url) async {
  try {
    final resp = await Dio().head(url);
    return resp.statusCode == 200;
  } catch (e) {
    print('update file not avaliable: $e');
    return false;
  }
}

Future<void> doAndroidUpdate(BuildContext context, {bool force = false}) async {
  final update = await locator<CustedService>().getUpdate();
  if (update == null) return;
  print('Update avaliable: $update');

  final settings = locator<SettingStore>();
  final ignore = settings.ignoreUpdate.fetch();
  final urgent = update.level != null && update.level >= 2;

  if (!urgent && !force && ignore != null && ignore >= update.build) {
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

  if (!await isFileAvaliable(update.file.url)) {
    return;
  }

  AppRoute(
    title: '更新',
    page: UpdateNoticePage(update),
  ).go(context, rootNavigator: true);
}

Future<void> doTestflightUpdate(
  BuildContext context, {
  bool force = false,
}) async {
  final update = await locator<CustedService>().getTestflithgUpdate();
  if (update == null) return;

  print('Update avaliable: $update');

  final isCurrentVersionTooOld = BuildData.build < update.min;
  final shouldShowDialog = force || isCurrentVersionTooOld;

  if (shouldShowDialog) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('新版本可用'),
          content: Text('使用旧版本可能导致某些功能无法使用'),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('前往Testflight更新'),
              isDefaultAction: true,
              onPressed: () {
                openUrl(update.url);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
