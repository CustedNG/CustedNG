import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';

class UserProvider extends BusyProvider {
  UserProfile _profile;
  UserProfile get profile => _profile;

  Future<void> getInitData() async {
    final userData = await locator.getAsync<UserDataStore>();
    _profile = userData.profile.fetch();

    if (_profile != null) {
      print('use cached profile: $_profile');
      notifyListeners();
    }
  }

  Future<void> updateProfileData() async {
    try {
      await busyRun(_updateProfileData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateProfileData() async {
    _profile = await User().getProfile();
    final userData = await locator.getAsync<UserDataStore>();
    userData.profile.put(_profile);
  }

  Future<void> clearProfileData() async {
    _profile = null;
    final userData = await locator.getAsync<UserDataStore>();
    userData.profile.delete();
    notifyListeners();
  }
}
