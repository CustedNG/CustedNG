import 'package:custed2/res/image_res.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class JwCaptchaHelpPage extends StatefulWidget {
  JwCaptchaHelpPage({Key key}) : super(key: key);

  @override
  _JwCaptchaHelpPageState createState() => _JwCaptchaHelpPageState();
}

class _JwCaptchaHelpPageState extends State<JwCaptchaHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                Widget image = ExtendedImage(
                  image: ImageRes.jwCaptchaHelp,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) => GestureConfig(
                      inPageView: true, initialScale: 1.0, cacheGesture: true),
                );
                return image;
              },
              itemCount: 1,
              scrollDirection: Axis.horizontal,
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
