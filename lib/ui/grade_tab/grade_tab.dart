import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_title.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';

class GradeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarTitle(
          child: Text('成绩查询'),
        ),
        middle: Container(),
      ),
      child: PlaceholderWidget(),
    );
  }
}
