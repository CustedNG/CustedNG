import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/store/custom_schedule_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';


class AddCustomSchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCustomSchedulePageState();
}

class _AddCustomSchedulePageState extends State<AddCustomSchedulePage> {
  final customScheduleStore = locator<CustomScheduleStore>();

  final _studentNumberTextFieldController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final navBarText = TextStyle(
      fontWeight: FontWeight.bold,
    );

    // final profile = await user.getProfile();

    return Scaffold(
      appBar: NavBar.material(
        context: context,
        middle: Text('添加课表', style: navBarText),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: double.infinity, minHeight: double.infinity),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: TextField(
                controller: _studentNumberTextFieldController,
                decoration: InputDecoration(
                  labelText: '学号',
                  icon: Icon(Icons.person)
                ),
              ),
            ),
            Center(
              child: TextButton(
                child: Text(
                  _isLoading ? '加载中...' : '完成',
                  style: TextStyle(
                      color: _isLoading
                          ? Colors.grey
                          : (isDark(context) ? Colors.white : Colors.black)),
                ),
                onPressed: () async {
                  if (!_isLoading) _handleInput();
                  // Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleInput() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String text = _studentNumberTextFieldController.text.trim();
      if (text.isEmpty) {
        _showBadNotice(reason: '请输入学号');
        return;
      }
      if (customScheduleStore
          .getProfileList()
          .any((element) => element.studentNumber == text)) {
        _showBadNotice(reason: "此学号已存在");
        return;
      }

      final jwService = locator<JwService>();
      final rawList = await jwService.getProfileByStudentNumber(text);
      final profiles = _filterListPrivacySafe(rawList, text);
      if (profiles.isEmpty) {
        _showBadNotice(reason: '未能查询到此学号');
        return;
      }
      if (profiles.length == 1) {
        _addProfile(profiles.first);
      } else {
        profiles.sort(
            (a, b) => a.studentNumber?.compareTo(b?.studentNumber ?? '0') ?? 0);
        _showProfileSelectorMenu(profiles);
        // _showBadNotice(reason: '请输入精确的学号');
      }
    } catch (e) {
      _showBadNotice(reason: '解析失败：$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<CustomScheduleProfile> _filterListPrivacySafe(
      List<CustomScheduleProfile> profiles, String input) {
    if (profiles.length == 1) return profiles;
    return <CustomScheduleProfile>[
      for (final profile in profiles)
        if (profile.name == input || profile.studentNumber == input) profile
    ];
  }

  bool _addProfile(CustomScheduleProfile profile) {
    if (customScheduleStore
        .getProfileList()
        .any((element) => element.uuid == profile?.uuid)) {
      _showBadNotice(reason: "相同项目已存在");
      return false;
    }
    customScheduleStore.addProfile(profile);
    Navigator.of(context).pop();
    return true;
  }

  void _showBadNotice(
      {String title = '不能添加此项目', String reason = "未知原因"}) async {
    if (mounted) setState(() {});
    showRoundDialog(
      context,
      title,
      Text(reason),
      [
        TextButton(
          child: Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ]
    );
  }

  void _showProfileSelectorMenu(List<CustomScheduleProfile> profiles) async {
    final child = List.empty();
    for (final profile in profiles) {
      child.add(
        TextButton(
          child: Text('${profile.name} ${profile.studentNumber}'),
          onPressed: () {
            if (_addProfile(profile)) {
              Navigator.of(context).pop();
            }
          },
        )
      );
    }
            
    showRoundDialog(
        context,
        '请选择',
        Column(children: child),
        [
          TextButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]
    );
  }
}
