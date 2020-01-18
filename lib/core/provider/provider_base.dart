import 'package:flutter/widgets.dart';

class ProviderBase with ChangeNotifier {
  void setState(void callback()) {
    callback();
    notifyListeners();
  }
}
