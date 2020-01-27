import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/cupertino.dart';

class HomeNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      title: Text('通知'),
      content: Text('无通知..'),
    );
  }
}
