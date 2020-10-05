import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/iecard_service.dart';
import 'package:pedantic/pedantic.dart';

class UserProvider extends BusyProvider {
  UserProfile _profile;
  UserProfile get profile => _profile;

  bool _loggedIn = false;
  bool get loggedIn => _profile != null && _loggedIn;

  final _initialized = Completer();
  Future get initialized => _initialized.future;

  Future<void> loadLocalData() async {
    final userData = await locator.getAsync<UserDataStore>();
    _profile = userData.profile.fetch();
    _loggedIn = userData.loggedIn.fetch();

    if (_profile != null) {
      print('use cached profile: $_profile');
      notifyListeners();
    }

    _initialized.complete(null);
  }

  Future<void> login() async {
    await busyRun(() async {
      await _updateProfileData();
      await _setLoginState(true);
      _afterLogin();
    });
  }

  Future<void> logout() async {
    unawaited(_setLoginState(false));
    notifyListeners();
  }

  Future<void> _updateProfileData() async {
    _profile = await User().getProfile();
    final userData = await locator.getAsync<UserDataStore>();
    unawaited(userData.profile.put(_profile));
  }

  Future<void> _setLoginState(bool state) async {
    _loggedIn = state;
    final userData = await locator.getAsync<UserDataStore>();
    unawaited(userData.loggedIn.put(state));
  }

  void _afterLogin() async {
    final schedule = locator<ScheduleProvider>();
    final grade = locator<GradeProvider>();
    locator<PersistCookieJar>().deleteAll();
    await schedule.updateScheduleData(reset: true);
    await grade.updateGradeData();
    // call login() here to improve iecard open speed.
    await IecardService().login();
  }
}
