import 'dart:async';
import 'dart:io';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:r_upgrade/r_upgrade.dart';

void updateCheck(BuildContext context, {bool force = false}) async {
  print('Checking for updates...');
  final update = locator<AppProvider>().config?.update;

  _doUpdate(context, update, force: force);
}

Future<bool> isFileAvailable(String url) async {
  try {
    final resp = await Client().head(url.uri);
    return resp.statusCode == 200;
  } catch (e) {
    print('update file not available: $e');
    return false;
  }
}

Future<void> _update(BuildContext context, String url, int version) async {
  if (Platform.isAndroid) {
    await RUpgrade.upgrade(url,
        fileName: 'CustedNG_${version}_Arm64.apk', isAutoRequestInstall: true);
  } else if (Platform.isIOS) {
    await RUpgrade.upgradeFromAppStore('1483085363');
  } else {
    showRoundDialog(context, '注意', Text('当前平台不支持应用内升级'), [
      TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('好'))
    ]);
  }
}

Future<void> _doUpdate(
  BuildContext context,
  CustedConfigUpdate update, {
  bool force = false,
}) async {
  if (update == null) return;

  final versions = update.version;
  final urls = update.url;
  final priorities = update.priority;
  final version = Platform.isAndroid ? versions.android : versions.ios;
  final url = Platform.isAndroid ? urls.android : urls.ios;
  final priority = Platform.isAndroid ? priorities.android : priorities.ios;

  print('Update: $version, Current: ${BuildData.build}');

  locator<AppProvider>().newest = version;
  final shouldShowDialog = force || priority >= 1;

  if (shouldShowDialog) {
    if (version < BuildData.build) {
      if (force) {
        showSnackBar(context, '当前没有新版本');
      }
      return;
    }

    if (!(await isFileAvailable(url)) && Platform.isAndroid) {
      showSnackBar(context, '新版本暂时无法下载');
      return;
    }

    if (priority == 1) {
      showSnackBarWithAction(context, 'Custed有更新啦，Ver：${version}', '更新',
          () => _update(context, url, version));
      return;
    }

    showRoundDialog(
      context,
      'v1.0.${version}',
      Text(update.changelog.ios),
      [
        TextButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('更新'),
          onPressed: () async {
            Navigator.of(context).pop();
            _update(context, url, version);
          },
        ),
      ],
    );
  }
}
