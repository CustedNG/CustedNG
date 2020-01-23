import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PresistentStore<E> {
  final String boxName = 'defaultBox';

  Box<E> box;

  Future<PresistentStore<E>> init() async {
    box = await Hive.openBox(boxName);
    return this;
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

  Future<void> delete() {
    return _box.delete(_key);
  }
}