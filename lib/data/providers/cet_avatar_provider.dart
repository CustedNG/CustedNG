import 'dart:convert';
import 'dart:typed_data';

import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/jw_service.dart';

class CetAvatarProvider extends BusyProvider {
  Uint8List _avatar;
  Uint8List get avatar => _avatar;

  Future<void> getAvatar() async {
    busyRun(_getAvatar);
  }

  Future<void> _getAvatar() async {
    final studentInfo = await locator<JwService>().getStudentInfo();
    final imgBase64 = studentInfo.XJZPBlob.Base64String;
    _avatar = base64.decode(imgBase64);
  }
}
