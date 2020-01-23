import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 4)
class UserProfile {
  UserProfile({
    this.displayName,
    this.department,
  });

  @HiveField(0)
  String displayName;

  @HiveField(1)
  String department;

  @override
  String toString() {
    return 'Profile<$displayName>';
  }
}