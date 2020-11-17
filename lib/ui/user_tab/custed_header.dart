import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';

class CustedHeader extends StatefulWidget{
  @override
  _CustedHeaderState createState() => _CustedHeaderState();
}

class _CustedHeaderState extends State<CustedHeader> with TickerProviderStateMixin{
  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  double _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.9,
      duration: Duration(milliseconds: 777),
    );
    _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic
    )..addListener(() { setState(() {});});
  }

  @override
  Widget build(BuildContext context){
    _scale = 1 - _curvedAnimation.value;

    return Padding(
        padding: EdgeInsets.all(20.0),
        child: GestureDetector(
            onTap: (){
              _controller.forward();
              Future.delayed(Duration(milliseconds: 300), () => _controller.reverse());
            },
            child: Transform.scale(
              scale: _scale,
              child:Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                clipBehavior: Clip.antiAlias,
                semanticContainer: false,
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: (MediaQuery.of(context).size.width - 40) / 110,
                      child: Image.asset(
                          'assets/bg/abstract-dark.jpg',
                          fit: BoxFit.cover
                      ),
                    ),
                    Positioned(
                        top: 30,
                        left: 30,
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: DarkModeFilter(
                                  child: Image.asset(
                                      'assets/icon/custed_lite.png',
                                      height: 50,
                                      width: 50
                                  ),
                                )
                            ),
                            SizedBox(width: 40.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Custed NG',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Ver: Material 1.0.${BuildData.build}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                )
                              ],
                            )
                          ],
                        )
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}