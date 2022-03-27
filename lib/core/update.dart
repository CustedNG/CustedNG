import 'dart:async';
import 'dart:io';

import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/update/update_notice_page.dart';
import 'package:custed2/core/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

updateCheck(BuildContext context, {bool force = false}) async {
  print('Checking for updates...');

  if (Platform.isAndroid) {
    doAndroidUpdate(context, force: force);
    return;
  }
  doiOSUpdate(context, force: force);
}

Future<bool> isFileAvailable(String url) async {
  try {
    final resp = await Dio().head(url);
    return resp.statusCode == 200;
  } catch (e) {
    print('update file not available: $e');
    return false;
  }
}

Future<void> doAndroidUpdate(BuildContext context, {bool force = false}) async {
  final update = await locator<CustedService>().getUpdate();
  if (update == null) return;
  print('Update available: $update');

  final settings = locator<SettingStore>();
  final ignore = settings.ignoreUpdate.fetch();
  final urgent = update.level != null && update.level >= 2;

  locator<AppProvider>().build = update.build;

  if (!urgent && !force && ignore != null && ignore >= update.build) {
    print('$ignore is skipped by user.');
    print('Update Skipped.');
    return;
  }

  if (!force && update.build <= BuildData.build) {
    print('Update Ignored due to current: ${BuildData.build}, '
        'update: ${update.build}');
    return;
  }

  if (!await isFileAvailable(update.file.url)) {
    return;
  }

  if (update.level >= 1 || force) {
    if (force && update.build < BuildData.build) {
      showSnackBar(context, '当前没有新版本');
      return;
    }

    final updatePage = AppRoute(
      title: '更新',
      page: UpdateNoticePage(update),
    );
    if (update.level == 1) {
      showSnackBarWithAction(context, 'Custed有更新啦，Ver：${update.build}', '更新',
          () => updatePage.go(context));
    } else {
      updatePage.go(context);
    }
  }
}

Future<void> doiOSUpdate(
  BuildContext context, {
  bool force = false,
}) async {
  final update = await locator<CustedService>().getiOSUpdate();
  if (update == null) return;

  print('Update: $update, Current: ${BuildData.build}');

  final isCurrentVersionTooOld = BuildData.build < update.min;
  locator<AppProvider>().build = update.newest;
  final shouldShowDialog = force || isCurrentVersionTooOld;

  if (shouldShowDialog) {
    if (update.newest < BuildData.build) {
      showSnackBar(context, '当前没有新版本');
      return;
    }
    showRoundDialog(
      context,
      update.title,
      Text(update.content),
      [
        TextButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('前往更新'),
          onPressed: () async {
            for (var url in update.urls) {
              if (await openUrl(url)) {
                break;
              }
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
