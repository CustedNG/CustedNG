import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key key,
    @required this.title,
    this.onTap,
    this.content = "",
    this.rightBtn,
    this.textAlign = TextAlign.start,
    this.titleStyle,
    this.contentStyle,
    this.height,
    this.isShowArrow = true,
    this.icon,
  }): super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Widget rightBtn;
  final double height;
  final bool isShowArrow;
  final Icon icon;
  @override
  Widget build(BuildContext context) {

    return Container(
        height: this.height ?? 55.0,
        margin: EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          clipBehavior: Clip.antiAlias,
          semanticContainer: false,
          child: InkWell(
              onTap: this.onTap,
              child: Stack(
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      this.icon ?? Container(),
                      SizedBox(width: 10.0),
                      Text(this.title),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(this.content,
                              textAlign: this.textAlign,
                              overflow: TextOverflow.ellipsis,
                              style: this.contentStyle ??
                                  TextStyle(
                                    fontSize: 14.0
                                  )),
                        ),
                      ),
                      this.isShowArrow
                          ? Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            )
                          : Container(),
                      SizedBox(width: 10.0),
                    ],
                  ),
                  this.rightBtn ?? Container()
                ],
              )),
        )
    );
  }
}