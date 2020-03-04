import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:flutter/painting.dart';

abstract class CustUser {
  final _mysso = locator<MyssoService>();

  Future<UserProfile> getProfile() async {
    final profile = await _mysso.getProfile();
    return UserProfile()
      ..displayName = profile.name
      ..department = profile.college ?? '';
  }

  Future<ImageProvider> getAvatar() async => ImageRes.defaultAvatar;
}
