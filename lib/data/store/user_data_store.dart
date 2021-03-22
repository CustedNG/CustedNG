import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/user_profile.dart';

class UserDataStore with PersistentStore {
  @override
  final boxName = 'user';

  StoreProperty<String> get username => property('username');
  StoreProperty<String> get password => property('password');
  StoreProperty<UserProfile> get profile => property('profile');
  StoreProperty<bool> get loggedIn => property('loggedIn', defaultValue: false);
}
