import 'package:custed2/config/route.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/update/update_notice_page.dart';
import 'package:flutter/cupertino.dart';

updateCheck(BuildContext context, {bool force = false}) async {
  print('Checking for updates...');

  final update = await locator<CustedService>().getUpdate();
  if (update == null) return;

  print('Update avaliable: ');

  AppRoute(
    title: '更新',
    page: UpdateNoticePage(update),
  ).go(context, rootNavigator: true);
}
