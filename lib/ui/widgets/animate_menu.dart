import 'package:custed2/config/routes.dart';
import 'package:flutter/material.dart';

class AnimateMenu extends StatefulWidget {
  @override
  createState() => _AnimateMenuState();
}

class _AnimateMenuState extends State<AnimateMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation,
      degFourTranslationAnimation,
      degFiveTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 377));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        IgnorePointer(
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(getRadiansFromDegree(270),
              degOneTranslationAnimation.value * 100),
          child: Transform(
            transform:
                Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degOneTranslationAnimation.value),
            alignment: Alignment.center,
            child: CircularButtonItem(
              color: Colors.lightBlueAccent,
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              onClick: () {
                print('First Button');
              },
              text: '申请出校',
            ),
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(getRadiansFromDegree(225),
              degTwoTranslationAnimation.value * 100),
          child: Transform(
            transform:
                Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degTwoTranslationAnimation.value),
            alignment: Alignment.center,
            child: CircularButtonItem(
              color: Colors.orange,
              icon: Icon(Icons.local_library, color: Colors.white),
              onClick: () => mapPage.go(context),
              text: '图书馆',
            ),
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(getRadiansFromDegree(315),
              degTwoTranslationAnimation.value * 100),
          child: Transform(
            transform:
                Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degThreeTranslationAnimation.value),
            alignment: Alignment.center,
            child: CircularButtonItem(
              color: Colors.redAccent,
              icon: Icon(Icons.map, color: Colors.white),
              onClick: () => mapPage.go(context),
              text: '校地图',
            ),
          ),
        ),
        Transform(
          transform:
              Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
          alignment: Alignment.center,
          child: CircularButton(
            width: 60,
            height: 60,
            icon: Icon(
              Icons.navigation,
            ),
            onClick: () {
              if (animationController.isCompleted) {
                animationController.reverse();
              } else {
                animationController.forward();
              }
            },
          ),
        )
      ],
    ));
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      padding: EdgeInsets.all(7.0),
      child: GestureDetector(child: icon, onTap: onClick),
    );
  }
}

class CircularButtonItem extends StatelessWidget {
  final Color color;
  final Function onClick;
  final String text;
  final Icon icon;

  CircularButtonItem({this.color, this.onClick, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularButton(
          height: 43,
          color: color,
          onClick: onClick,
          icon: icon,
        ),
        Material(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            height: 13,
            width: 40,
            child: Center(
              child: Text(
                text,
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 9.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
