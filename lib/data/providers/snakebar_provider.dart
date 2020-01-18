import 'package:custed2/core/provider/provider_base.dart';
import 'package:flutter/cupertino.dart';

class SnakebarProvider extends ProviderBase {
  bool _isActive = false;
  Widget _widget;
  Color _bgColor;

  bool get isActive => _isActive;
  Widget get widget => _widget;
  Color get bgColor => _bgColor;

  info(String message) {
    _isActive = true;
    _widget = Text(
      message,
      style: TextStyle(
        fontSize: 15,
        color: CupertinoColors.white,
      ),
    );
    _bgColor = CupertinoColors.activeBlue;
    notifyListeners();
  }

  clear() {
    _isActive = false;
    notifyListeners();
  }
}
