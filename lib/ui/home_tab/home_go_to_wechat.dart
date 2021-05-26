import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';

class GoToWechat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: NavbarText('一卡通'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('一卡通相关业务推荐使用'),
                SizedBox(height: 5),
                Text('信息化中心微信公众号办理'),
                SizedBox(height: 30),
                Image(
                  image: ImageRes.wechatStep1,
                  width: 250,
                ),
                SizedBox(height: 30),
                Image(
                  image: ImageRes.wechatStep2,
                  width: 200,
                ),
                SizedBox(height: 20),
                Image(
                  image: ImageRes.wechatStep3,
                  width: 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
