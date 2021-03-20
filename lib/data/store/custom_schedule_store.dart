import 'dart:convert';

import 'package:custed2/core/store/presistent_store.dart';
import 'package:custed2/data/models/custom_schedule_profile.dart';
import 'package:custed2/data/models/schedule.dart';

class CustomScheduleStore with PresistentStore {
  @override
  final boxName = 'custom_schedule';

  void saveUUID(String studentNumber, String uuid) {
    if (studentNumber.length > 64) {
      throw Exception('$studentNumber is too long');
    }
    box.put("UUID_$studentNumber", uuid);
  }

  String getUUID(String studentNumber, {String defaultValue}) {
    return box.get(studentNumber, defaultValue: defaultValue);
  }

  void saveScheduleWithUUID(String uuid, Schedule schedule) {
    if (schedule == null) return;
    uuid = uuid.trim();
    box.put("Schedule_$uuid", schedule);
  }

  Schedule getScheduleWithUUID(String uuid) {
    uuid = uuid.trim();
    return box.get("Schedule_$uuid");
  }

  void saveProfileList(List<CustomScheduleProfile> objList) {
    final mapList = [for (final item in objList) item.toPrimitiveMap()];
    box.put("ProfileList_", json.encode(mapList));
  }

  List<CustomScheduleProfile> getProfileList() {
    final rawString =
        box.get("ProfileList_", defaultValue: "[]");
    final List jsonObj = json.decode(rawString);
    return jsonObj.map((e) => CustomScheduleProfile.fromPrimitiveMap(e)).toList();
  }

  List<CustomScheduleProfile> addProfile(CustomScheduleProfile profile) {
    final list = getProfileList();
    list.add(profile);
    saveProfileList(list);
    return list;
  }

  List<CustomScheduleProfile> removeProfileByUUID(String uuid) {
    final list = getProfileList();
    final newList = <CustomScheduleProfile>[
      for (final item in list)
        if (item.uuid != uuid) item
    ];
    saveProfileList(newList);
    return newList;
  }
}

class InvalidKeyException implements Exception {
  InvalidKeyException(this.message);

  final String message;

  @override
  String toString() => 'InvalidKeyException: $message';
}
