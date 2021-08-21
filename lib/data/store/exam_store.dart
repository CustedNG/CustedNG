import 'dart:convert';

import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/jw_exam.dart';

class ExamStore with PersistentStore<String> {
  @override
  final boxName = 'exam';

  void put(JwExamData exam) {
    this.box.put('exam', jsonEncode(exam));
  }

  JwExamData fetch() {
    final data = this.box.get('exam');
    if (data == null) return null;

    return JwExamData.fromJson(jsonDecode(data));
  }
}
