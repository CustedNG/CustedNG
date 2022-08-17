import 'dart:async';
import 'dart:io';

import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/update/update_notice_page.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void updateCheck(BuildContext context, {bool force = false}) async {
  print('Checking for updates...');
  final update = locator<AppProvider>().config?.update;

  if (Platform.isAndroid) {
    doAndroidUpdate(context, update, force: force);
    return;
  }
  doiOSUpdate(context, update, force: force);
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

Future<void> doAndroidUpdate(BuildContext context, CustedConfigUpdate update,
    {bool force = false}) async {
  if (update == null) return;
  print('Update available: $update');

  final settings = locator<SettingStore>();
  final ignore = settings.ignoreUpdate.fetch();
  final priority = update.priority.android;
  final urgent = priority != null && priority >= 2;
  final build = update.version.android;

  locator<AppProvider>().build = build;

  if (!urgent && !force && ignore != null && ignore >= build) {
    print('$ignore is skipped by user.');
    print('Update Skipped.');
    return;
  }

  if (!force && build <= BuildData.build) {
    print('Update Ignored due to current: ${BuildData.build}, '
        'update: ${build}');
    return;
  }

  if (!await isFileAvailable(update.url.android)) {
    return;
  }

  if (priority >= 1 || force) {
    if (force && build < BuildData.build) {
      showSnackBar(context, '当前没有新版本');
      return;
    }

    final updatePage = AppRoute(
      title: '更新',
      page: UpdateNoticePage(update),
    );
    if (priority == 1) {
      showSnackBarWithAction(context, 'Custed有更新啦，Ver：${build}', '更新',
          () => updatePage.go(context));
    } else {
      updatePage.go(context);
    }
  }
}

Future<void> doiOSUpdate(
  BuildContext context,
  CustedConfigUpdate update, {
  bool force = false,
}) async {
  if (update == null) return;
  print('Update: $update, Current: ${BuildData.build}');

  final build = update.version.ios;

  locator<AppProvider>().build = build;
  final shouldShowDialog = force || update.priority.ios >= 1;

  if (shouldShowDialog) {
    if (build < BuildData.build) {
      showSnackBar(context, '当前没有新版本');
      return;
    }
    showRoundDialog(
      context,
      '更新',
      Text(update.changelog.ios),
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
            await openUrl(update.url.ios);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
