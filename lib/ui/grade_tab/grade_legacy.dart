import 'dart:math';
import 'package:custed2/res/constants.dart';
import 'package:custed2/core/extension/color.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/models/grade_detail.dart';
import 'package:custed2/data/models/grade_term.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/grade_tab/sliver_header_delegate.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final setting = locator<SettingStore>();

class GradeReportLegacy extends StatefulWidget {
  @override
  _GradeReportLegacyState createState() => _GradeReportLegacyState();
}

class _GradeReportLegacyState extends State<GradeReportLegacy> {
  PageController controller;
  bool isRefreshing = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  double currentPage;
  final _refreshController = RefreshController(initialRefresh: false);

  GradeProvider get gradeProvider =>
      Provider.of<GradeProvider>(context, listen: false);

  Grade get grade => gradeProvider.grade;

  int get initPage => (grade?.terms?.length ?? 1) - 1;

  @override
  void didChangeDependencies() {
    final current = currentPage ?? initPage;
    controller = PageController(initialPage: current.toInt());
    setState(() => currentPage = current.toDouble());
    controller.addListener(() {
      setState(() => currentPage = controller.page);
    });
    super.didChangeDependencies();
  }

  void _showSelector(BuildContext context) async {
    final terms = grade.terms.map((t) => t.termName).toList();
    final current = currentPage.round().clamp(0, terms.length - 1);

    List<Widget> items = terms.map((term) {
      return Center(
        child: Text(
          term,
          style: TextStyle(fontSize: 17.0),
        ),
      );
    }).toList();

    await showRoundDialog(
        context,
        '选择学期',
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.black12,
                ),
              ),
              top: 55,
              bottom: 55,
              left: 0,
              right: 0,
            ),
            Container(
              height: 150.0,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 37,
                diameterRatio: 1.2,
                onSelectedItemChanged: (n) => setState(() {
                  controller.animateToPage(
                    n,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }),
                controller: FixedExtentScrollController(initialItem: current),
                physics: FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) => items[index],
                    childCount: items.length),
              ),
            ),
          ],
        ),
        []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
          leading: SizedBox(),
          context: context,
          middle: NavbarText('成绩'),
          trailing: [
            grade?.terms?.isNotEmpty == true
                ? IconButton(
                    icon: Icon(Icons.format_list_numbered),
                    onPressed: () => _showSelector(context))
                : SizedBox()
          ]),
      body: Material(
        child: PageView(
          controller: controller,
          children: <Widget>[
            for (var i = 0; i < (grade?.terms?.length ?? 1); i++)
              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                physics: BouncingScrollPhysics(),
                header: MaterialClassicHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: _buildTermReport(context, i),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle resolveWithBackground(TextStyle style) => style.copyWith(
      color: Theme.of(context).primaryColor.isBrightColor
          ? Colors.black87
          : Colors.white);

  void _onRefresh() async {
    try {
      if (isRefreshing) return;
      isRefreshing = true;
      await gradeProvider.updateGradeData();
      _refreshController.refreshCompleted();
      showSnackBar(context, '刷新成功');
      isRefreshing = false;
      setState(() {});
    } catch (e) {
      _refreshController.refreshFailed();
      showSnackBar(context, '刷新失败');
      isRefreshing = false;
      rethrow;
    }
  }

  Widget _buildTermReport(BuildContext context, int year) {
    final report = CustomScrollView(
      slivers: <Widget>[
        _buildInfo(context, year),
        SliverSafeArea(
          sliver: SliverToBoxAdapter(
            child: _buildReport(context, level: year),
          ),
        )
      ],
    );
    return report;
  }

  Widget _buildInfo(BuildContext context, int level) {
    final info = grade?.terms?.elementAt(level);
    final diff = currentPage - level;
    final value = -2.5 * diff.abs() + 1.0;
    final pageOpacity = min(max(value, 0.0), 1.0);

    final maxHeight = 150.0;
    final minHeight = 50.0;
    final maxOffset = 50.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverHeaderDelegate(
        maxHeight: maxHeight,
        minHeight: minHeight,
        builder: (context, offset, _) {
          final offsetDiff = maxOffset - offset;
          final scrollOpacity = min(offsetDiff.abs() / maxOffset, 1.0);
          final data = offset > maxOffset
              ? Center(child: _buildSmallData(context, level, info))
              : _buildFullData(context, level, info);
          final result = Opacity(
            opacity: min(pageOpacity, scrollOpacity),
            child: data,
          );
          return Container(
            // height: 150 - offset,
            color: Theme.of(context).primaryColor,
            child: result,
          );
        },
      ),
    );
  }

  static String gradePoint(int level, GradeTerm term) {
    final noResultString = '无成绩';
    final dontCountElective = setting.dontCountElectiveCourseGrade.fetch();

    final noElectionGP = term?.averageGradePointNoElectiveCourse;
    final gp = dontCountElective
        ? (noElectionGP.isNaN
            ? noResultString
            : noElectionGP?.toStringAsFixed(3))
        : term?.averageGradePoint?.toStringAsFixed(3);

    if (gp != null) {
      return gp;
    }

    if (dontCountElective &&
        term?.averageGradePoint != null &&
        term?.averageGradePointNoElectiveCourse == null) {
      return '刷新后计算';
    }

    return noResultString;
  }

  void refresh() {
    setState(() {});
  }

  Widget _buildFullData(BuildContext context, int level, GradeTerm term) {
    final setting = locator<SettingStore>();

    final gradePointLabel =
        setting.dontCountElectiveCourseGrade.fetch() ? '去选修绩点' : '本学期绩点';

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: [
            Text(
              gradePoint(level, term),
              style: resolveWithBackground(textTheme.headline4)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
            Text(gradePointLabel,
                style: resolveWithBackground(textTheme.caption)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildInfoItem(
              context,
              tag: '学期',
              value: term?.termName ?? '?',
            ),
            _buildInfoItem(
              context,
              tag: '学分',
              value: term?.creditTotal?.toString() ?? '0',
            ),
            _buildInfoItem(
              context,
              tag: '通过',
              value: term == null
                  ? '0/0'
                  : '${term.subjectCount}/${term.subjectPassed}',
            ),
            _buildInfoItem(
              context,
              tag: '总绩点',
              value: grade?.averageGradePoint?.toString() ?? 'N/A',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallData(BuildContext context, int level, GradeTerm term) {
    final setting = locator<SettingStore>();

    final gradePointLabel =
        setting.dontCountElectiveCourseGrade.fetch() ? '去选修绩点' : '学期绩点';

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSmallInfoItem(
          context,
          tag: '学期',
          value: term?.termName ?? '?',
        ),
        _buildSmallInfoItem(
          context,
          tag: '学分',
          value: term?.creditTotal?.toString() ?? '0',
        ),
        _buildSmallInfoItem(
          context,
          tag: gradePointLabel,
          value: gradePoint(level, term),
        ),
        _buildSmallInfoItem(
          context,
          tag: '通过',
          value: term == null
              ? '0/0'
              : '${term.subjectCount}/${term.subjectPassed}',
        ),
        _buildSmallInfoItem(
          context,
          tag: '总绩点',
          value: grade?.averageGradePoint?.toString() ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildSmallInfoItem(
    BuildContext context, {
    @required String value,
    @required String tag,
    //String unit = '',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(value, style: resolveWithBackground(textTheme.caption)),
        SizedBox(height: 3),
        Text(
          tag,
          style: resolveWithBackground(textTheme.caption),
        )
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    @required String value,
    @required String tag,
    /*String unit = ''*/
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(value, style: resolveWithBackground(textTheme.bodyText2)),
          ],
        ),
        Text(tag, style: resolveWithBackground(textTheme.caption)),
      ],
    );
  }

  Widget _buildReport(BuildContext context, {@required int level}) {
    final term = grade?.terms?.elementAt(level);
    if (term == null) {
      return Column(
        children: <Widget>[
          SizedBox(height: 55),
          PlaceholderWidget(text: '无成绩信息'),
        ],
      );
    }

    final items = term.grades.map((exam) => _ReportItem(exam)).toList();
    return Container(
      padding: EdgeInsets.all(15.0),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: items,
          ),
        ),
      ),
    );
  }
}

class _ReportItem extends StatefulWidget {
  final GradeDetail exam;

  _ReportItem(this.exam);

  @override
  __ReportItemState createState() => __ReportItemState();
}

class __ReportItemState extends State<_ReportItem>
    with AutomaticKeepAliveClientMixin {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final nameTextTheme = TextStyle(
      color: resolveWithBackground(context),
      fontWeight: FontWeight.bold,
    );
    final content = isExpanded
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(widget.exam.lessonName, style: nameTextTheme),
              ),
              // SizedBox(height: 10),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '成绩 : ${formatGrade(widget.exam)}',
                    ),
                    SizedBox(width: 20),
                    Text(
                      '类别 : ${widget.exam.lessonType}',
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '学分 : ${widget.exam.credit}',
                    ),
                    SizedBox(width: 20),
                    Text(
                      '学时 : ${widget.exam.schoolHour}',
                    ),
                    SizedBox(width: 20),
                    Text(
                      '状态 : ${widget.exam.testStatus}',
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.exam.lessonName,
                style: nameTextTheme,
                overflow: TextOverflow.fade,
              ),
              _buildScore(widget.exam.rawMark),
            ],
          );
    final item = AnimatedContainer(
      height: isExpanded ? 115 : 57,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 500),
      child: Card(
        elevation: 3,
        shape: roundShape,
        child: Padding(
          padding: EdgeInsets.only(left: 17, right: 17),
          child: Align(
            child: content,
          ),
        ),
      ),
    );
    return GestureDetector(
      child: item,
      onTap: toggleExpansion,
    );
  }

  Color _generateCardColor(bool pass) {
    return pass ? null : Colors.red;
  }

  Widget _buildScore(String score) {
    bool pass = score > 59;
    pass ??= true;
    return Container(
      child: Text(
        score,
        style: TextStyle(color: pass ? Colors.green : Colors.white),
      ),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _generateCardColor(pass),
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

String formatGrade(GradeDetail detail) {
  if (detail.rawMark == null || detail.rawMark.isEmpty) {
    return '?';
  }

  return detail.rawMark;
}
