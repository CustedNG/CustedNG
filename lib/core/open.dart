import 'package:url_launcher/url_launcher.dart';

Future<bool> openUrl(String url) async {
  print('openUrl $url');

  if (!await canLaunch(url)) {
    print('canLaunch false');
    return false;
  }

  if (await launch(url, forceSafariVC: false)) {
    return true;
  }

  print('launch $url failed');

  return false;
}
