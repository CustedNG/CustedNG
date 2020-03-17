import 'dart:math';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/models/grade_detail.dart';
import 'package:custed2/data/models/grade_term.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:custed2/ui/grade_tab/sliver_header_delegate.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

const colorNavBar = Color(0xFF2F83F6);
const colorMain = Color(0xFF3D93F8);
const colorButtom = Color(0xFF5395F7);

const textStyleInfo = TextStyle(
  color: CupertinoColors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

final textStyleTag = TextStyle(
  color: CupertinoColors.white.withAlpha(200),
  fontWeight: FontWeight.w500,
  fontSize: 14,
);

const textStyleName = TextStyle(
  color: Color(0xFF418DF7),
  fontWeight: FontWeight.bold,
  fontSize: 14,
);

final textStyleNameDark = textStyleName.copyWith(
  color: Colors.white70,
);
final textStyleField = TextStyle(
  color: CupertinoColors.black.withAlpha(170),
  fontWeight: FontWeight.bold,
  fontSize: 14,
);
final textStyleFieldDark = textStyleField.copyWith(
  color: CupertinoColors.white.withAlpha(170),
);
const textStyleMark = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
);

final textStyleRankingTitle = TextStyle(
    color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 18);

final textStyleRankingDescription = TextStyle(
  color: Colors.blueGrey,
  fontSize: 13,
);

final textStyleRankingBoxTitle =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

final textStyleRankingBoxContext = TextStyle(
  fontSize: 13,
);

class GradeReportLegacy extends StatefulWidget {
  @override
  _GradeReportLegacyState createState() => _GradeReportLegacyState();
}

class _GradeReportLegacyState extends State<GradeReportLegacy> {
  PageController controller;

  double currentPage;

  GradeProvider get gradeProvider => Provider.of<GradeProvider>(context);

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyMiddle: false,
        backgroundColor: CupertinoColors.activeBlue,
        actionsForegroundColor: CupertinoColors.white,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Text('成绩查询', style: textStyleInfo.copyWith(fontSize: 17)),
        ),
      ),
      child: SafeArea(
        child: Material(
          child: PageView(
            controller: controller,
            children: <Widget>[
              for (var i = 0; i < (grade?.terms?.length ?? 1); i++)
                _buildTermReport(context, i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermReport(BuildContext context, int year) {
    final report = CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await gradeProvider.updateGradeData();
          },
        ),
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
            color: Color(0xFF3D93F8),
            child: result,
          );
        },
      ),
    );
  }

  static String gradePoint(int level, GradeTerm term) {
    final setting = locator<SettingStore>();
    final dontCountElective = setting.dontCountElectiveCourseGrade.fetch();

    final gp = dontCountElective
        ? term?.averageGradePointNoElectiveCourse?.toStringAsFixed(3)
        : term?.averageGradePoint?.toStringAsFixed(3);

    if (gp != null) {
      return gp;
    }
    if (dontCountElective &&
        term?.averageGradePoint != null &&
        term?.averageGradePointNoElectiveCourse == null) {
      return '刷新后计算';
    }

    return 'N/A';
  }

  Widget _buildFullData(BuildContext context, int level, GradeTerm term) {
    final setting = locator<SettingStore>();

    final gradePointLabel =
        setting.dontCountElectiveCourseGrade.fetch() ? '去选修绩点' : '本学期绩点';

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              gradePoint(level, term),
              style: textStyleInfo.copyWith(fontSize: 32),
            ),
            SizedBox(height: 5),
            Text(gradePointLabel, style: textStyleTag.copyWith(fontSize: 14))
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
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
    String unit = '',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(value, style: textStyleInfo.copyWith(fontSize: 14)),
          ],
        ),
        SizedBox(height: 3),
        Text(tag, style: textStyleTag.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context,
      {@required String value, @required String tag, String unit = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(value, style: textStyleInfo),
          ],
        ),
        Text(tag, style: textStyleTag),
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
    final report = Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
    return Container(
      // color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.all(15.0),
      child: report,
    );
  }
}

class _ReportItem extends StatefulWidget {
  final GradeDetail exam;

  _ReportItem(this.exam);

  @override
  __ReportItemState createState() => __ReportItemState();
}

class __ReportItemState extends State<_ReportItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle gradeTextStyle;
    if (widget.exam.mark >= 60) {
      gradeTextStyle = textStyleMark.copyWith(
          color: DynamicColor(
        Color(0xFF2ACD75),
        Color(0xFF059c0a),
      ).resolve(context));
    } else if (widget.exam.mark >= 0) {
      gradeTextStyle = textStyleMark.copyWith(
          //b3ad00
          color: DynamicColor(
        Color(0xfffc037b),
        Color(0xFFa6462b),
      ).resolve(context));
    } else {
      gradeTextStyle = textStyleMark.copyWith(
          color: DynamicColor(
        Color(0xfffcc603),
        Color(0xffb3ad00),
      ).resolve(context));
    }
    final bgColor = CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? Colors.grey[800]
        : CupertinoColors.white;
    final fieldTextTheme =
        CupertinoTheme.brightnessOf(context) == Brightness.dark
            ? textStyleFieldDark
            : textStyleField;
    final nameTextTheme =
        CupertinoTheme.brightnessOf(context) == Brightness.dark
            ? textStyleNameDark
            : textStyleName;
    final content = isExpanded
        ? Container(
            color: bgColor,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.exam.lessonName, style: nameTextTheme),
                      SizedBox(width: 5),
                      Text(
                        widget.exam.lessonType,
                        style: textStyleMark.copyWith(
                            color: DynamicColor(
                          Color(0xFF2ACD75),
                          Color(0xFF059c0a),
                        ).resolve(context)),
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
                        '成绩 : ${widget.exam.rawMark}',
                        style: gradeTextStyle,
                      ),
                      SizedBox(width: 20),
                      Text(
                        '类别 : ${widget.exam.lessonType}',
                        style: fieldTextTheme,
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
                        style: fieldTextTheme,
                      ),
                      SizedBox(width: 20),
                      Text(
                        '学时 : ${widget.exam.schoolHour}',
                        style: fieldTextTheme,
                      ),
                      SizedBox(width: 20),
                      Text(
                        '状态 : ${widget.exam.testStatus}',
                        style: fieldTextTheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: bgColor,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.exam.lessonName,
                  style: nameTextTheme,
                ),
                Text(
                  widget.exam.rawMark,
                  style: gradeTextStyle,
                ),
              ],
            ),
          );
    final item = AnimatedContainer(
        height: isExpanded ? 115 : 57,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(milliseconds: 500),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: CupertinoTheme.brightnessOf(context) == Brightness.dark
                  ? null
                  : Border.all(color: CupertinoColors.black.withAlpha(50)),
              borderRadius: BorderRadius.circular(5)),
          child: content,
        ));
    return GestureDetector(
      child: item,
      onTap: toggleExpansion,
    );
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
