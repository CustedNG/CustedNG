import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/res/image_res.dart';
import 'package:flutter/painting.dart';

class VisitorUser implements User {
  @override
  Future<Schedule> getSchedule() => null;

  @override
  Future<Grade> getGrade() => null;

  @override
  Future<UserProfile> getProfile() async => UserProfile()
    ..displayName = '游客'
    ..department = null;

  @override
  Future<ImageProvider> getAvatar() async => ImageRes.custedLiteIcon;
}
