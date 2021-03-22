import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/grade.dart';

class GradeStore with PersistentStore<Grade> {
  @override
  final boxName = 'grade';

  void checkIn(Grade grade) {
    if (grade == null) {
      return;
    }

    final shouldAddToBox =
        head == null || grade.versionHash != head.versionHash;

    if (shouldAddToBox) {
      box.add(grade);
    } else {
      head.createdAt = grade.createdAt;
      head.save();
    }
  }

  Grade get head {
    if (box.isEmpty) return null;
    return box.getAt(box.length - 1);
  }
}
