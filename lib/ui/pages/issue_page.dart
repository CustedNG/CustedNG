import 'package:custed2/core/route.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';

class IssuePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: NavbarText('反馈👉'),
        trailing: [
          IconButton(
              icon: Icon(Icons.feedback),
              onPressed: () => AppRoute(
                  page: WebviewBrowser('https://cust.cc/go/feedback')
              ).go(context)
          )
        ]
      ),
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
      fontSize: 27,
    );
    final contentTextStyle = TextStyle(
      fontSize: 17,
    );

    return [
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
                    'A:可能由于某些机型中的安全键盘导致，可以尝试临时关闭\n\n'
                    '加入用户组获取最新资讯\n',
                style: contentTextStyle
            ),
            Image.asset(
                'assets/user_group.jpg',
                height: MediaQuery.of(context).size.height * 0.3
            )
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
                'Q: 如何连续翻页\n'
                'A: 长按课表左/右 翻页箭头即可\n'
                'Q:如何快速回到当前周\n'
                'A:长按课表中”第x周“即可\n',
          style: contentTextStyle
        ),
      ),
    ];
  }
}