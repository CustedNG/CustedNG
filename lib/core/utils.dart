import 'dart:io';

import 'package:custed2/core/extension/color.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/fade_in.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/src/types.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}

void showSnackBarWithAction(
    BuildContext context, String content, String action, FutureOr onTap) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    action: SnackBarAction(
      label: action,
      onPressed: onTap,
    ),
  ));
}

void showSnackBarWithPage(
    BuildContext context, String content, AppRoute route, String actionText) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    action: SnackBarAction(
      onPressed: () => route.go(context),
      label: actionText,
    ),
  ));
}

void showCatchSnackBar(BuildContext context, Function func, String message) {
  Future.sync(func).catchError((e) => showSnackBar(context, message ?? '$e'));
}

Future<T> showRoundDialog<T>(
    BuildContext context, String title, Widget child, List<Widget> actions,
    {EdgeInsets padding}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return CardDialog(
          title: Text(title),
          content: child,
          actions: actions,
          padding: padding,
        );
      });
}

extension StringX on String {
  Uri get uri => Uri.parse(this);

  URLRequest get uq => URLRequest(url: this.uri);

  bool operator <(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s < num.parse(x) : s < x;
  }

  bool operator >(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s > num.parse(x) : s > x;
  }

  bool operator <=(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s <= num.parse(x) : s <= x;
  }

  bool operator >=(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s >= num.parse(x) : s >= x;
  }
}

Widget MyImage(String url) {
  return ExtendedImage.network(
    url,
    cache: true,
    fit: BoxFit.cover,
    loadStateChanged: (xState) {
      final state = xState.extendedImageLoadState;
      switch (state) {
        case LoadState.loading:
          return Center(heightFactor: 4, child: CircularProgressIndicator());
        case LoadState.failed:
          return Center(
              child: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => xState.reLoadImage(),
          ));
        case LoadState.completed:
          return FadeIn(
              child: ExtendedRawImage(
            image: xState.extendedImageInfo?.image,
          ));
        default:
          return Center(child: Icon(Icons.sync_problem));
      }
    },
  );
}

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

Widget buildSwitch(BuildContext context, StoreProperty<bool> prop,
    {Function(bool) func}) {
  return ValueListenableBuilder(
    valueListenable: prop.listenable(),
    builder: (context, value, widget) {
      return DarkModeFilter(
        child: Switch(
            value: value,
            activeColor: Color(locator<SettingStore>().appPrimaryColor.fetch()),
            onChanged: (value) {
              if (func != null) func(value);
              return prop.put(value);
            }),
      );
    },
  );
}

/// 根据背景色判断是否显示强调色
Color resolveWithBackground(BuildContext context) {
  final primary = Color(locator<SettingStore>().appPrimaryColor.fetch());
  final background = Theme.of(context).backgroundColor;
  if (primary.isBrightColor != background.isBrightColor) {
    return primary;
  }
  return null;
}

/// 根据Appbar背景色判断使用黑/白色
Color judgeWhiteOrBlack4AppbarContent(BuildContext context) {
  final primary = Color(locator<SettingStore>().appPrimaryColor.fetch());
  return primary.isBrightColor ? Colors.black : Colors.white;
}

void setSystemBottomNavigationBarColor(BuildContext context) {
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]); // Enable Edge-to-Edge on Android 10+
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.transparent, // Setting a transparent navigation bar color
      systemNavigationBarContrastEnforced: true, // Default
      systemNavigationBarIconBrightness: isDark(context)
          ? Brightness.light
          : Brightness.dark, // This defines the color of the scrim
    ));
  }
}
