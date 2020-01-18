import 'package:custed2/core/provider/provider_state.dart';
import 'package:flutter/widgets.dart';

class ProviderBase with ChangeNotifier {
  void setState(void callback()) {
    callback();
    notifyListeners();
  }
}
