import 'package:url_launcher/url_launcher_string.dart';

Future<bool> openUrl(String url, {LaunchMode mode}) async {
  if (!await canLaunchUrlString(url)) {
    return false;
  }

  if (await launchUrlString(url,
      mode: mode ?? LaunchMode.externalApplication)) {
    print('[URL] Launching: $url');
    return true;
  }

  print('[URL] Launch failed: $url');
  return false;
}
