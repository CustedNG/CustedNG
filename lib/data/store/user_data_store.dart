import 'package:custed2/core/store/presistent_store.dart';
import 'package:custed2/data/models/user_profile.dart';

class UserDataStore with PresistentStore {
  @override
  final boxName = 'user';

  Property<String> get username => property('username');
  Property<String> get password => property('password');
  Property<UserProfile> get profile => property('profile');
}