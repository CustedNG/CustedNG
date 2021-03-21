import 'package:custed2/data/store/custom_schedule_store.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class AddCustomSchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCustomSchedulePageState();
}

class _AddCustomSchedulePageState extends State<AddCustomSchedulePage> {
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

    return Scaffold(
      backgroundColor: theme.textFieldListBackgroundColor,
      appBar: NavBar.material(
        context: context,
        leading: TextButton(
            child: Text('取消', style: navBarText),
            onPressed: () {
              Navigator.pop(context);
            }),
        middle: Text('添加课表', style: navBarText),
      ),
      body: DefaultTextStyle(
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
                child: TextField(
                  controller: _studentNumberTextFieldController,
                  decoration: InputDecoration(
                    labelText: '学号'
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
                            : Colors.blue),
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
      if(text.isEmpty) {
        _showBadNotice(reason: '请输入学号');
        return;
      }
      final jwService = locator<JwService>();
      final lists = await jwService.getProfileByStudentNumber(text);
      if (lists.length == 1) {
        final store = locator<CustomScheduleStore>();
        store.addProfile(lists.first);
        Navigator.of(context).pop();
      } else {
        if(lists.isEmpty){
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

  void _showBadNotice({String reason = '请输入精确学号'}) async {
    showRoundDialog(
      context,
      '无法解析学号',
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
}
