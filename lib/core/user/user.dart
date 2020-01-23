import 'package:custed2/core/user/undergraduate_user.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:flutter/painting.dart';

// User is an abstract layer upon different backend of different types of users.
abstract class User {
  factory User() => UndergraduateUser();

  Future<Schedule> getSchdeule();

  Future<UserProfile> getProfile();

  Future<ImageProvider> getAvatar();
}