import 'dart:io';

import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/update/update_notice_page.dart';
import 'package:custed2/ui/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  doTestFlightUpdate(context, force: force);
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

  if (!await isFileAvailable(update.file.url)) {
    return;
  }

  AppRoute(
    title: '更新',
    page: UpdateNoticePage(update),
  ).go(context);
}

Future<void> doTestFlightUpdate(
  BuildContext context, {
  bool force = false,
}) async {
  final update = await locator<CustedService>().getTestFlightUpdate();
  if (update == null) return;

  print('Update available: $update');

  final isCurrentVersionTooOld = BuildData.build < update.min;
  final shouldShowDialog = force || isCurrentVersionTooOld;

  if (shouldShowDialog) {
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
