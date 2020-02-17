import 'package:url_launcher/url_launcher.dart';

Future<bool> openUrl(String url) async {
  if (!await canLaunch(url)) return false;
  return launch(url);
}
