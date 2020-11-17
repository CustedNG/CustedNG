import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SchoolMapPage extends StatefulWidget {
  final int initialIndex;
  final PageController controller;

  SchoolMapPage({Key key, PageController controller, this.initialIndex})
      : controller = controller ?? PageController(),
        super(key: key);

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<SchoolMapPage> {
  static const maps = [
    ImageRes.custEMapSimple,
    ImageRes.custSMapSimple,
    ImageRes.custWMapSimple
  ];

  static const darkMaps = [
    ImageRes.custEMapSimpleDark,
    ImageRes.custSMapSimpleDark,
    ImageRes.custWMapSimpleDark
  ];

  int currentMapIndex;

  @override
  void initState() {
    super.initState();
    currentMapIndex = widget.initialIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final effectMaps = isDark(context) ? darkMaps : maps;
    final background = isDark(context) ? CupertinoColors.darkBackgroundGray : Colors.white;
    final deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: effectMaps[index],
              );
            },
            itemCount: 3,
            backgroundDecoration: BoxDecoration(color: background),
            pageController: widget.controller,
            enableRotation: true,
            onPageChanged: (index) {
              setState(() {
                currentMapIndex = index;
              });
            },
          ),
          Positioned(
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: currentMapIndex,
              children: {
                0: Text('东区'),
                1: Text('西区'),
                2: Text('南区'),
              },
              onValueChanged: (index) {
                setState(() {
                  widget.controller.animateToPage(
                    index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                });
              },
            ),
            top: 50,
            right: deviceWidth * 0.3,
            left: deviceWidth * 0.3,
          ),
          Positioned(
            child: GestureDetector(
              child: Icon(Icons.close, size: 27),
              onTap: () => Navigator.of(context).pop(),
            ),
            top: 50,
            left: 20,
          )
        ],
      ),
    );
  }
}
