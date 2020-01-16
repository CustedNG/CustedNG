import 'package:custed2/data/models/user.dart';
import 'package:custed2/data/providers/hive_provider.dart';

class UserProvider extends HiveProvider<User> {
  final boxName = 'user';

  Future<void> setUser(User user) {
    return box.put('user', user);
  }

  User getUser() {
    return box.get('user');
  }
  
}