import 'package:custed2/res/constants.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/custom_schedule_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_custom_schedule_page.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectSchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectSchedulePageState();
}

class _SelectSchedulePageState extends State<SelectSchedulePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    final customScheduleStore = locator<CustomScheduleStore>();
    final profiles = customScheduleStore.getProfileList();

    // final profile = await user.getProfile();

    return Scaffold(
        appBar: NavBar.material(
          context: context,
          middle: Text('选择课表'),
          trailing: [
            IconButton(
              onPressed: () async {
                await AppRoute(
                  title: '添加',
                  page: AddCustomSchedulePage(),
                ).go(context);
                setState(() {});
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: ListView(
            children: <Widget>[
              _buildListItem(null, "当前用户", user.profile.studentNumber),
              for (final profile in profiles)
                _buildListItem(profile, profile.name, profile.studentNumber,
                    displayUUID: profile.uuid),
            ],
          ),
        ));
  }

  Widget _buildListItem(
      CustomScheduleProfile profile, String displayName, String studentNumber,
      {String displayUUID}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: GestureDetector(
        child: Card(
          elevation: 3.0,
          shape: roundShape,
          clipBehavior: Clip.antiAlias,
          semanticContainer: false,
          child: Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      displayName,
                    ),
                    SizedBox(width: 10),
                    Text(studentNumber ?? "")
                  ],
                ),
                if (displayUUID != null) Text(displayUUID),
              ],
            ),
            padding: EdgeInsets.all(17),
          ),
        ),
        onTap: () {
          _switchToProfile(profile);
          Navigator.of(context).pop();
        },
        onLongPress: () {
          if (profile != null) {
            showRoundDialog(
              context,
              '确定删除吗？',
              Text('${profile.name}-${profile.studentNumber}'),
              [
                TextButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('确定', style: TextStyle(color: Colors.pinkAccent)),
                  onPressed: () {
                    _removeProfile(profile);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _switchToProfile(CustomScheduleProfile profile) {
    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);

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
