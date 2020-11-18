import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0, left: 0, bottom: 0, right: 0,
            child: Container(
                child: PhotoViewGallery.builder(
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: isDark(context)
                      ? darkMaps[index]
                      : maps[index],
                );
              },
              itemCount: 3,
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor
              ),
              pageController: widget.controller,
              enableRotation: true,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
            )),
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
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(Icons.close, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
