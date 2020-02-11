import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/res/image_res.dart';
import 'package:flutter/painting.dart';

class UndergraduateUser implements User {
  @override
  Future<Schedule> getSchdeule() => null;

  @override
  Future<UserProfile> getProfile() async => UserProfile()
    ..displayName = '游客'
    ..department = null;

  @override
  Future<ImageProvider> getAvatar() async => ImageRes.defaultAvatar;
}
