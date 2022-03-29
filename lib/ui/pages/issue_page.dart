import 'package:custed2/constants.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/url_text.dart';
import 'package:flutter/material.dart';

class IssuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(context: context, middle: Text('问题反馈')),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: _buildCards(context),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    final titleTextStyle = TextStyle(
      fontSize: 23,
    );
    final contentTextStyle = TextStyle(
      fontSize: 15,
    );

    return [
      HomeCard(
        title: Text('用户群', style: titleTextStyle),
        content: UrlText('网页反馈已被弃用。\n如果有问题需要反馈，请入用户群 $joinQQUserGroup', replace: '点击加入'),
      ),
      SizedBox(height: 20),
      HomeCard(
        title: Text('常见问题', style: titleTextStyle),
        content: Column(
          children: [
            Text(
                '\n'
                'Q:传统登录提示输入手机号\n'
                'A:由于统一认证系统近期强制要求绑定手机号，'
                '使用统一认证登录然后绑定手机号即可继续使用传统登录\n'
                'Q:统一认证登录无法输入密码\n'
                'A:可能由于某些机型中的安全键盘导致，可以尝试临时关闭',
                style: contentTextStyle),
          ],
        ),
      ),
      SizedBox(height: 20),
      HomeCard(
        title: Text('课程表', style: titleTextStyle),
        content: Text(
            '\n课表&成绩信息仅供参考\n'
            '请与教务系统中信息核对后使用!\n'
            'Q:课表缺课\n'
            'A:CustedNG课表与教务课表保持同步，请尝试查看教务课表是否缺课\n'
            'Q:如何将课程加入系统日历\n'
            'A:在课表中长按课程即可\n'
            'Q:如何连续翻页\n'
            'A:长按课表 左/右 翻页箭头即可\n'
            'Q:如何快速回到当前周\n'
            'A:长按课表中”第x周“即可',
            style: contentTextStyle),
      ),
    ];
  }
}
