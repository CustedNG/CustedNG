import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: '界面，焕然一新',
        description: '不仅是更精美的Material Design UI，还有更丰富的选项',
        pathImage: 'assets/intro/home.png',
        backgroundColor: Colors.cyan,
      ),
    );
    slides.add(
      Slide(
        title: '账户页面',
        description: '在该版本中，我们将用户界面移至了首页左上角Navigation',
        pathImage: 'assets/intro/navigation.gif',
        backgroundColor: Colors.pinkAccent,
      ),
    );
    slides.add(
      Slide(
        title: '设置项目',
        description: '其次，设计了全新的设置界面，提供更丰富的选择，更精美的UI',
        pathImage: 'assets/intro/setting.gif',
        backgroundColor: Colors.purple,
      ),
    );
  }

  void onDonePress() {
    locator<UserDataStore>().haveInit.put(true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Color btnColor = Colors.white24;
    double btnBorderRadius = 20;
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onDonePress,
      borderRadiusDoneBtn: btnBorderRadius,
      borderRadiusPrevBtn: btnBorderRadius,
      borderRadiusSkipBtn: btnBorderRadius,
      colorDoneBtn: btnColor,
      colorPrevBtn: btnColor,
      colorSkipBtn: btnColor,
      nameSkipBtn: '跳过',
      nameDoneBtn: '完成',
      nameNextBtn: '继续',
      namePrevBtn: '返回',
      colorActiveDot: Colors.white70,
      colorDot: Colors.white24,
    );
  }
}