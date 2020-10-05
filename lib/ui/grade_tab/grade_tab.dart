import 'package:after_layout/after_layout.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradeTab extends StatefulWidget {
  @override
  _GradeTabState createState() => _GradeTabState();
}

class _GradeTabState extends State<GradeTab> with AfterLayoutMixin<GradeTab> {
  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context);
    return PlaceholderWidget(
      text: gradeProvider.grade?.averageGradePoint?.toString(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    final user = locator<UserProvider>();
    await user.initialized;
    if (!user.loggedIn) return;

    final gradeProvider = Provider.of<GradeProvider>(context);
    if (gradeProvider.isBusy) return;

    gradeProvider.updateGradeData().timeout(Duration(seconds: 10));
  }
}
