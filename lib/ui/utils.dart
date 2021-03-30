import 'package:custed2/ui/widgets/card_dialog.dart';
import 'package:custed2/ui/widgets/fade_in.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/src/types.dart';

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

void showRoundDialog(BuildContext context, String title, Widget child, List<Widget> actions){
  showDialog(
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

extension UriX on String {
  Uri get uri => Uri.parse(this);

  URLRequest get uq => URLRequest(url: this.uri);
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
          return Center(child: CircularProgressIndicator());
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