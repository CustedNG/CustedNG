import 'package:url_launcher/url_launcher_string.dart';

Future<bool> openUrl(String url) async {
  if (!await canLaunchUrlString(url)) {
    return false;
  }

  if (await launchUrlString(url)) {
    print('[URL] Launching: $url');
    return true;
  }

  print('[URL] Launch failed: $url');
  return false;
}
