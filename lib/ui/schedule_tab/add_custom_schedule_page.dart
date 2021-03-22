import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/store/custom_schedule_store.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';

import '../../locator.dart';

class AddCustomSchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCustomSchedulePageState();
}

class _AddCustomSchedulePageState extends State<AddCustomSchedulePage> {
  final customScheduleStore = locator<CustomScheduleStore>();

  AppThemeResolved theme;
  final _studentNumberTextFieldController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    theme = AppTheme.of(context);
    final navBarText = TextStyle(
      color: theme.navBarActionsColor,
      fontWeight: FontWeight.bold,
    );

    // final profile = await user.getProfile();

    return CupertinoPageScaffold(
      backgroundColor: theme.textFieldListBackgroundColor,
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarButton.leading(
            child: Text('取消', style: navBarText),
            onPressed: () {
              Navigator.pop(context);
            }),
        middle: Text('添加课表', style: navBarText),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.textColor,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: CupertinoTextField(
                  controller: _studentNumberTextFieldController,
                  placeholder: '学号',
                ),
              ),
              Center(
                child: CupertinoButton(
                  child: Text(
                    _isLoading ? '加载中...' : '完成',
                    style: TextStyle(
                        color: _isLoading
                            ? CupertinoColors.inactiveGray
                            : CupertinoColors.activeBlue),
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
      final profiles = await jwService.getProfileByStudentNumber(text);
      if (profiles.length == 1) {
        _addProfile(profiles.first);
      } else {
        if (profiles.isEmpty) {
          _showBadNotice(reason: '未能查询到此学号');
        } else {
          _showBadNotice(reason: '请输入精确的学号');
        }
      }
    } catch (e) {
      _showBadNotice(reason: '解析失败：$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addProfile(CustomScheduleProfile profile) {
    if (customScheduleStore
        .getProfileList()
        .any((element) => element.uuid == profile?.uuid)) {
      _showBadNotice(reason: "相同项目已存在");
      return;
    }
    customScheduleStore.addProfile(profile);
    Navigator.of(context).pop();
  }

  void _showBadNotice(
      {String title = '不能添加此项目', String reason = "未知原因"}) async {
    showCupertinoDialog(
      context: context,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(reason),
            actions: [
              CupertinoDialogAction(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }
}
