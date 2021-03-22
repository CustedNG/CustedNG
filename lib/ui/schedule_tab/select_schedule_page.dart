import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/custom_schedule_store.dart';
import 'package:custed2/ui/schedule_tab/add_custom_schedule_page.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class SelectSchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectSchedulePageState();
}

class _SelectSchedulePageState extends State<SelectSchedulePage> {
  AppThemeResolved theme;

  @override
  Widget build(BuildContext context) {
    theme = AppTheme.of(context);
    final navBarTextStyle = TextStyle(
      color: theme.navBarActionsColor,
      fontWeight: FontWeight.bold,
    );

    final user = Provider.of<UserProvider>(context, listen: false);
    final customScheduleStore = locator<CustomScheduleStore>();
    final profiles = customScheduleStore.getProfileList();

    // final profile = await user.getProfile();

    return CupertinoPageScaffold(
      backgroundColor: theme.textFieldListBackgroundColor,
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarButton.leading(
            child: Text('完成', style: navBarTextStyle),
            onPressed: () {
              Navigator.pop(context);
            }),
        middle: Text('选择课表', style: navBarTextStyle),
        trailing: NavBarButton.trailing(
          child: GestureDetector(
              onTap: () {
                AppRoute(
                  title: '添加',
                  page: AddCustomSchedulePage(),
                  then: (result) {
                    setState(() {});
                  },
                ).popup(context);
              },
              child: Text(
                "添加",
                style: navBarTextStyle,
              )),
        ),
      ),
      child: DefaultTextStyle(
          style: TextStyle(
            color: theme.textColor,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: ListView(
              children: <Widget>[
                _buildListItem(null, "当前用户", user.profile.studentNumber),
                for (final profile in profiles)
                  _buildListItem(profile, profile.name, profile.studentNumber,
                      displayUUID: profile.uuid),
              ],
            ),
          )),
    );
  }

  Widget _buildListItem(
      CustomScheduleProfile profile, String displayName, String studentNumber,
      {String displayUUID}) {
    final secondaryTextStyle =
        TextStyle(color: theme.lightTextColor, fontSize: 12);
    return GestureDetector(
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    displayName,
                    style: TextStyle(color: theme.textColor),
                  ),
                  SizedBox(width: 10),
                  Text(studentNumber ?? "", style: secondaryTextStyle)
                ],
              ),
              if (displayUUID != null)
                Text(displayUUID, style: secondaryTextStyle),
            ],
          ),
        ),
        onPressed: () {
          _switchToProfile(profile);
          Navigator.of(context).pop();
        },
      ),
      onLongPress: () {
        if (profile != null) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('想要删除此记录吗？'),
              actions: [
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  isDefaultAction: true,
                  onPressed: () {
                    _removeProfile(profile);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _switchToProfile(CustomScheduleProfile profile) {
    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    final store = locator<CustomScheduleStore>();

    scheduleProvider.customScheduleProfile = profile;
    scheduleProvider.loadLocalData(refreshAnyway: true, updateOnAbsent: true);
  }

  void _removeProfile(CustomScheduleProfile profile) {
    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    final store = locator<CustomScheduleStore>();
    store.removeProfileByUUID(profile.uuid);
    if (scheduleProvider.customScheduleProfile?.uuid == profile.uuid) {
      _switchToProfile(null);
    }
    Navigator.of(context).pop();
    setState(() {});
  }
}
