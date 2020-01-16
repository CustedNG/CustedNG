import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

abstract class HiveProvider<T> extends ChangeNotifier {
  String boxName;

  Future<void> ensureBoxOpen() {
    if (Hive.isBoxOpen(boxName)) {
      return null;
    }

    return Hive.openBox(boxName);
  }

  Box<T> get box => Hive.box(boxName);
}