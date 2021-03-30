import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/zoomable.dart';
import 'package:flutter/material.dart';

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
  PhotoViewMap(
      this.name,
      this.map,
      this.position,
      this.darkPosition,
      this.offset
  );

  static const flagSize = 4.7;
  final String name;
  final CustCompusMap map;
  final Offset position;
  final Offset darkPosition;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = isDark(context);
    return ZoomableWidget(
      initialOffset: offset,
      initialScale: map.initScale,
      minScale: map.minScale,
      maxScale: map.maxScale,
      child: Stack(
        children: <Widget>[
          FadeInImage(
            image: isDarkMode ? map.darkImage : map.image, 
            placeholder: MemoryImage(kTransparentImage),
            fadeInDuration: Duration(milliseconds: 277),
          ),
          Positioned(
            top: isDarkMode ? darkPosition.dy : position.dy,
            left: isDarkMode ? darkPosition.dx : position.dx,
            child: Icon(
              Icons.flag_sharp,
              size: flagSize,
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class Maps {
  static const custW = CustCompusMap(
    minScale: 4,
    maxScale: 7,
    initScale: 6,
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
        Offset(31, 28),
        Offset(27, 53),
      )
      ,
      PhotoViewMap(
        '东1东',
        custE,
        Offset(68, 28),
        Offset(68, 28),
        Offset(-8, 53),
      ),
      makeMap(
          '东区田径场',
          custE,
          25, 92
      ),
      makeMap('东1教', custE, 48, 27),
      makeMap('东2教', custE, 65, 12),
      PhotoViewMap(
        '机实',
        custE,
        Offset(95, 148),
        Offset(95, 148),
        Offset(-30, -65),
      ),
      PhotoViewMap(
        '东3教',
        custE,
        Offset(35, 12),
        Offset(35, 12),
        Offset(15, 65),
      ),
      PhotoViewMap(
        '研',
        custS,
        Offset(69, 97),
        Offset(72, 99),
        Offset(-5, -20),
      ),
      PhotoViewMap(
        '南实训',
        custS,
        Offset(67, 108),
        Offset(72, 108),
        Offset(-5, -20),
      ),
      PhotoViewMap(
        '南区体育馆',
        custS,
        Offset(81, 72),
        Offset(81, 72),
        Offset(-30, 10),
      ),
      PhotoViewMap(
        '西1教',
        custW,
        Offset(67, 99),
        Offset(68, 100),
        Offset(-9, -20),
      ),
      PhotoViewMap(
        '西区田',
        custW,
        Offset(68, 60),
        Offset(68, 60),
        Offset(-5, 20),
      ),
      PhotoViewMap(
        '西2教',
        custW,
        Offset(87, 106),
        Offset(89, 107),
        Offset(-15, -25),
      ),
      PhotoViewMap(
        '西区实',
        custW,
        Offset(49, 105),
        Offset(49, 106),
        Offset(-5, -25),
      ),
      PhotoViewMap(
        '西区攀岩',
        custW,
        Offset(93, 77),
        Offset(97, 76),
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
      PhotoViewMap('默认', custE, Offset.zero, Offset.zero, Offset.zero);
}
