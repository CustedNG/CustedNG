import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

class CustCompusMap {
  const CustCompusMap({
    this.minScale,
    this.maxScale,
    this.initScale,
    this.image,
    this.darkImage,
  });

  final double minScale;
  final double maxScale;
  final double initScale;
  final ImageProvider image;
  final ImageProvider darkImage;
}

class PhotoViewMap extends StatelessWidget {
  PhotoViewMap(this.name, this.map, this.position, this.offset);

  static const flagSize = 5.0;
  final String name;
  final CustCompusMap map;
  final Offset position;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    // final isDark = isDark(context);
    return ZoomableWidget(
      initialOffset: offset,
      initialScale: map.initScale,
      minScale: map.minScale,
      maxScale: map.maxScale,
      child: Container(
        child: Stack(
          children: <Widget>[
            TransitionToImage(
              // 暂时使用bright版地图 等dark版重做之后换上dark版
              image: map.image,
              // image: isDark(context) ? map.darkImage : map.image,
              // image: isDark ? map.darkImage : map.image,
              // placeholder: CircularProgressIndicator(),
              placeholder: Container(),
              duration: Duration(milliseconds: 300),
            ),
            Positioned(
              top: position.dy,
              left: position.dx,
              child: Icon(
                CupertinoIcons.flag,
                size: flagSize,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ],
        ),
      ),
    );

    // return PhotoView(
    //   basePosition: Alignment.topCenter,
    //   controller: PhotoViewController(
    //     initialPosition: Offset(offsetX ?? 0, offsetY ?? 0),
    //   ),
    //   backgroundDecoration: BoxDecoration(
    //     color: Color(0xFFF5F5F5),
    //   ),
    //   minScale: 0.1,
    //   maxScale: 1.0,
    //   initialScale: scale,
    //   imageProvider: img,
    // );
  }
}

class Maps {
  static const custW = CustCompusMap(
    minScale: 1,
    maxScale: 3,
    initScale: 2,
    image: ImageRes.custWMapSimple,
    darkImage: ImageRes.custWMapSimpleDark,
  );

  static const custE = CustCompusMap(
    minScale: 4,
    maxScale: 7,
    initScale: 6,
    image: ImageRes.custEMapSimple,
    darkImage: ImageRes.custEMapSimpleDark,
  );

  static const custS = CustCompusMap(
    minScale: 4,
    maxScale: 7,
    initScale: 6,
    image: ImageRes.custSMapSimple,
    darkImage: ImageRes.custSMapSimpleDark,
  );

  /// @dx positive = right
  /// @dy positive = down
  static PhotoViewMap makeMap(String name, CustCompusMap map, double dx,
      double dy) {
    return PhotoViewMap(
      name,
      map,
      Offset(dx, dy),
      Offset(-dx + 57, -dy + 80),
    );
  }

  static Widget search(String name) {
    final List<PhotoViewMap> _maps = [
      PhotoViewMap(
        '东1西',
        custE,
        Offset(31, 28),
        Offset(30, 53),
      )
      ,
      PhotoViewMap(
        '东1东',
        custE,
        Offset(68, 28),
        Offset(-8, 53),
      ),
      makeMap(
          '东区田径场',
          custE,
          25, 92
      ),
      makeMap('东2教', custE, 65, 12),
      PhotoViewMap(
        '机实',
        custE,
        Offset(95, 148),
        Offset(-30, -65),
      ),
      PhotoViewMap(
        '东3教',
        custE,
        Offset(35, 12),
        Offset(15, 65),
      ),
      PhotoViewMap(
        '研',
        custS,
        Offset(69, 97),
        Offset(-5, -15),
      ),
      makeMap('南实训', custS, 65, 108),
      PhotoViewMap(
        '南区体育馆',
        custS,
        Offset(81, 72),
        Offset(-30, 10),
      ),
      PhotoViewMap(
        '西1教',
        custW,
        Offset(67, 99),
        Offset(-9, -20),
      ),
      PhotoViewMap(
        '西区田',
        custW,
        Offset(68, 60),
        Offset(-5, 20),
      ),
      PhotoViewMap(
        '西2教',
        custW,
        Offset(87, 115),
        Offset(-15, -25),
      ),
      PhotoViewMap(
        '西区实',
        custW,
        Offset(49, 105),
        Offset(-5, -25),
      ),
      PhotoViewMap(
        '西区攀岩',
        custW,
        Offset(97, 77),
        Offset(-27, 5),
      ),
    ];

    for (final map in _maps) {
      if (name.contains(map.name)) {
        return map;
      }
    }
    return null;
  }

  static Widget get defaultMap =>
      PhotoViewMap('默认', custE, Offset.zero, Offset.zero);
}
