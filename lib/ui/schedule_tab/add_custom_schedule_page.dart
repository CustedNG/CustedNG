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
      if(text.isEmpty) {
        _showBadNotice();
        return;
      }
      final jwService = locator<JwService>();
      final lists = await jwService.getProfileByStudentNumber(text);
      if (lists.length == 1) {
        final store = locator<CustomScheduleStore>();
        store.addProfile(lists.first);
        Navigator.of(context).pop();
      } else {
        _showBadNotice();
      }
    } catch (e) {
      _showBadNotice();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBadNotice() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('无法解析学号'),
        content: Text('请输入精确学号'),
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
