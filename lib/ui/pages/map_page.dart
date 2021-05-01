import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  final int index;
  final String heroTag;
  final PageController controller;

  MapPage({Key key, this.controller, this.heroTag, this.index})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int currentIndex;
  static const List<String> area = ['东', '南', '西'];
  static const darkMaps = [
    ImageRes.custEMapSimpleDark,
    ImageRes.custSMapSimpleDark,
    ImageRes.custWMapSimpleDark
  ];
  static const maps = [
    ImageRes.custEMapSimple,
    ImageRes.custSMapSimple,
    ImageRes.custWMapSimple
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0, left: 0, bottom: 0, right: 0,
            child: ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                AssetImage item = isDark(context) ? darkMaps[index] : maps[index];
                Widget image = ExtendedImage(
                  image: item,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) => GestureConfig(
                    inPageView: true, 
                    initialScale: 1.0,
                    cacheGesture: false
                  ),
                );
                image = Container(
                  child: image,
                  padding: EdgeInsets.all(5.0),
                );
                if (index == currentIndex) {
                  return image;
                } else {
                  return image;
                }
              },
              itemCount: 3,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              controller: PageController(
                initialPage: currentIndex,
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text('${area[currentIndex]}区',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close, 
                size: 30, 
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
