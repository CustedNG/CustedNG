import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

import 'package:custed2/res/image_res.dart';

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
              image: map.image,
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

  static Widget search(String name) {
    final List<PhotoViewMap> _maps = [
      PhotoViewMap(
        '东1西',
        custE,
        Offset(31, 28),
        Offset(30, 53),
      ),
      PhotoViewMap(
        '东1东',
        custE,
        Offset(68, 28),
        Offset(-8, 53),
      ),
      PhotoViewMap(
        '东区田径场',
        custE,
        Offset(0, 0),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '东2教',
        custE,
        Offset(0, 0),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '东3教',
        custE,
        Offset(0, 0),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '研',
        custS,
        Offset(69, 97),
        Offset(-5, -15),
      ),
      PhotoViewMap(
        '南实训',
        custS,
        Offset(65, 108),
        Offset(-5, -25),
      ),
      PhotoViewMap(
        '南区体育馆',
        custS,
        Offset(81, 72),
        Offset(-30, 10),
      ),
      // 西区地图位置，小旗子的偏移没加
      PhotoViewMap(
        '西1教',
        custW,
        Offset(-53, -95),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '西2教',
        custW,
        Offset(-70, -95),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '西图',
        custW,
        Offset(-59, -70),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '西实',
        custW,
        Offset(-39, -95),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '西区攀岩馆',
        custW,
        Offset(-74, -70),
        Offset(0, 0),
      ),
      PhotoViewMap(
        '西区田径场',
        custW,
        Offset(-53, -50),
        Offset(0, 0),
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
