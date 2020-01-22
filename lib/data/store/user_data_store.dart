import 'package:custed2/core/store/presistent_store.dart';

class UserDataStore with PresistentStore {
  @override
  final boxName = 'user';

  Property<String> get username => property('username');
  Property<String> get password => property('password');
  Property<String> get realname => property('realname');
}