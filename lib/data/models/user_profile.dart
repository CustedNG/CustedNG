import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 4)
class UserProfile {
  UserProfile();

  @HiveField(0)
  String displayName;

  @HiveField(1)
  String department;

  @HiveField(2)
  String studentNumber;

  @override
  String toString() {
    return 'Profile<$displayName>';
  }
}
