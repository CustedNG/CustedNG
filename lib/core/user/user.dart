import 'package:custed2/core/user/undergraduate_user.dart';
import 'package:custed2/data/models/schedule.dart';

abstract class User {
  factory User() => UndergraduateUser();

  Future<Schedule> getSchdeule();
}