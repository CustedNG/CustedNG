import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/fade_in.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/src/types.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

void showSnackBar(BuildContext context, String content){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      )
  );
}

void showCatchSnackBar(BuildContext context, Function func, String message){
  Future.sync(func).catchError((e) => showSnackBar(context, message ?? '$e'));
}

Future<T> showRoundDialog<T>(BuildContext context, String title, Widget child, 
                    List<Widget> actions){
  return showDialog(
      context: context,
      builder: (ctx) {
        return CardDialog(
          title: Text(title),
          content: child,
          actions: actions,
        );
      }
  );
}

extension StringX on String {
  Uri get uri => Uri.parse(this);

  URLRequest get uq => URLRequest(url: this.uri);

  bool operator < (Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s < num.parse(x) : s < x;
  }
  bool operator > (Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s > num.parse(x) : s > x;
  }
  bool operator <= (Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s <= num.parse(x) : s <= x;
  }
  bool operator >= (Object x) {
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
          return Center(
            heightFactor: 4,
            child: CircularProgressIndicator()
          );
        case LoadState.failed:
          return Center(
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => xState.reLoadImage(),
            )
          );
        case LoadState.completed:
          return FadeIn(
            child: ExtendedRawImage(
              image: xState.extendedImageInfo?.image,
            )
          );
        default:
          return Center(child: Icon(Icons.sync_problem));
      }
    },
  );
}

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[
  0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,0x00,0x00,0x00,0x0D,0x49,0x48,
  0x44,0x52,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x08,0x06,0x00,0x00,
  0x00,0x1F,0x15,0xC4,0x89,0x00,0x00,0x00,0x0A,0x49,0x44,0x41,0x54,0x78,
  0x9C,0x63,0x00,0x01,0x00,0x00,0x05,0x00,0x01,0x0D,0x0A,0x2D,0xB4,0x00,
  0x00,0x00,0x00,0x49,0x45,0x4E,0x44,0xAE,
]);

Widget buildSwitch(BuildContext context, 
                    StoreProperty<bool> prop, {Function func}) {
  return Positioned(
      right: 0,
      child: ValueListenableBuilder(
        valueListenable: prop.listenable(),
        builder: (context, value, widget) {
          return DarkModeFilter(
            child: Switch(
                value: value, onChanged: (value) {
                  if (func != null) func();
                  return prop.put(value);
                }
            ),
          );
        },
      )
  );
}
