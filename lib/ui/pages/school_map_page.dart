import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SchoolMapPage extends StatefulWidget {
  final int index;
  final String heroTag;
  final PageController controller;

  SchoolMapPage({Key key, PageController controller, this.heroTag, this.index})
      : controller = controller ?? PageController(),
        super(key: key);

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<SchoolMapPage> {
  int currentMapIndex;
  static const List<String> area = ['东', '南', '西'];

  @override
  void initState() {
    super.initState();
    currentMapIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSlidingSegmentedControl<int>(
          groupValue: currentMapIndex,
          children: {
            0: Text('东区'),
            1: Text('西区'),
            2: Text('南区'),
          },
          onValueChanged: (index) {
            setState(() {
              currentMapIndex = index;
              widget.controller.animateToPage(
                index,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
      ),
      child: PhotoViewGallery.builder(
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: isDark(context)
                ? [
                    ImageRes.custEMapSimpleDark,
                    ImageRes.custSMapSimpleDark,
                    ImageRes.custWMapSimpleDark
                  ][index]
                : [
                    ImageRes.custEMapSimple,
                    ImageRes.custSMapSimple,
                    ImageRes.custWMapSimple
                  ][index],
          );
        },
        itemCount: 3,
        backgroundDecoration: null,
        pageController: widget.controller,
        enableRotation: true,
        onPageChanged: (index) {
          setState(
            () {
              currentMapIndex = index;
            },
          );
        },
      ),
    );

    // return Scaffold(
    //   body: Stack(
    //     children: <Widget>[
    //       Positioned(
    //         top: 0,
    //         left: 0,
    //         bottom: 0,
    //         right: 0,
    //         child: Container(
    //           child:
    //         ),
    //       ),
    //       Positioned(
    //         top: MediaQuery.of(context).padding.top + 15,
    //         width: MediaQuery.of(context).size.width,
    //         child: Center(
    //           child: Text('${area[currentMapIndex]}区',
    //               style: TextStyle(color: Colors.white, fontSize: 16)),
    //         ),
    //       ),
    //       Positioned(
    //         right: 10,
    //         top: MediaQuery.of(context).padding.top,
    //         child: IconButton(
    //           icon: Icon(
    //             Icons.close,
    //             size: 30,
    //             color: Colors.white,
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
