import 'package:custed2/core/service/presistent_service.dart';

class UserDataService with PresistentService {
  @override
  final boxName = 'user';

  Property<String> get username => property('username');
  Property<String> get password => property('password');
  Property<String> get realname => property('realname');
}