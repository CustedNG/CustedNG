import 'package:after_layout/after_layout.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_title.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GradeTab extends StatefulWidget {
  @override
  _GradeTabState createState() => _GradeTabState();
}

class _GradeTabState extends State<GradeTab> with AfterLayoutMixin<GradeTab> {
  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context);
    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarTitle(
          child: Text('成绩查询'),
        ),
        middle: Container(),
      ),
      child: PlaceholderWidget(
        text: gradeProvider.grade?.averageGradePoint?.toString(),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final user = locator<UserProvider>();
    if (!user.loggedIn) return;

    final gradeProvider = Provider.of<GradeProvider>(context);
    if (gradeProvider.isBusy) return;

    gradeProvider.updateGradeData().timeout(Duration(seconds: 10));
  }
}
