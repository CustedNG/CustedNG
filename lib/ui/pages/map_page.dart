import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MapPage extends StatefulWidget {
  final int index;
  final String heroTag;
  final PageController controller;

  MapPage({Key key, this.controller, this.heroTag, this.index})
      : super(key: key);

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<MapPage> {
  int currentIndex;

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
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
                child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
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
                  heroAttributes: widget.heroTag.isNotEmpty
                      ? PhotoViewHeroAttributes(tag: widget.heroTag)
                      : null,
                );
              },
              itemCount: 3,
              backgroundDecoration: null,
              pageController: widget.controller,
              enableRotation: true,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            )),
          ),
          Positioned(
            //图片index显示
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text("${currentIndex + 1}/3",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
