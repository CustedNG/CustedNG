import 'package:hive/hive.dart';

class PresistentService {
  final String boxName = 'defaultBox';

  Box box;

  Future<void> init() async {
    box = await Hive.openBox(boxName);
  }
}