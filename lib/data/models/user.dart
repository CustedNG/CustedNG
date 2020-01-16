import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User {
  /// 用户名(一卡通号)
  @HiveField(0)
  String username;

  /// 统一认证密码
  @HiveField(1)
  String password;
}
