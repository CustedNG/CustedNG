import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/data/debug_data.dart';

class DebugProvider extends ProviderBase {
  DebugData debugData = DebugData();

  void addText(String text) {
    debugData.addText(text);
    notifyListeners();
  }

  void addWidget(String text) {
    debugData.addText(text);
    notifyListeners();
  }

  void addError(Object error) {
    debugData.addError(error);
    notifyListeners();
  }
}