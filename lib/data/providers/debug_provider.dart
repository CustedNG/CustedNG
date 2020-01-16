import 'package:custed2/data/debug_data.dart';
import 'package:flutter/widgets.dart';

class DebugProvider extends ChangeNotifier {
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