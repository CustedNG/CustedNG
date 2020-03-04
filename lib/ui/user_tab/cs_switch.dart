import 'package:custed2/core/store/presistent_store.dart';
import 'package:flutter/cupertino.dart';

class CSSwitch extends StatelessWidget {
  CSSwitch(this.prop);

  final StoreProperty<bool> prop;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, value, widget) {
        return CupertinoSwitch(
            value: value, onChanged: (value) => prop.put(value));
      },
    );
  }
}
