import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PresistentService {
  final String boxName = 'defaultBox';

  Box box;

  Future<void> init() async {
    box = await Hive.openBox(boxName);
  }

  Property<T> property<T>(String key) {
    return Property<T>(box, key);
  }
}

class Property<T> {
  Property(this._box, this._key);

  Box _box;
  String _key;

  ValueListenable listenable() {
    return _box.listenable(keys: [_key]);
  }

  T fetch() {
    return _box.get(_key);
  }

  Future<void> put(T value) {
    return _box.put(_key, value);
  }
}