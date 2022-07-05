import 'package:url_launcher/url_launcher_string.dart';

Future<bool> openUrl(String url) async {
  print('openUrl $url');

  if (!await canLaunchUrlString(url)) {
    print('canLaunch false');
    return false;
  }

  if (await launchUrlString(url)) {
    return true;
  }

  print('launch $url failed');

  return false;
}
