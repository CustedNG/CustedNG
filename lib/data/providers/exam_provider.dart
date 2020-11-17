import 'dart:convert';

import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/jw_service.dart';

int sortExamByTime(JwExamRows a, JwExamRows b) {
  return a.examTask.beginDate.compareTo(b.examTask.beginDate);
}

class ExamProvider extends BusyProvider {
  JwExamData data;
  var show = false;
  var failed = false;

  Future<void> init() async {
    show = await CustedService().getShouldShowExam();

    if (!show) {
      return;
    }

    setBusyState(true);

    try {
      data = JwExam.fromJson(json.decode(await JwService().getExam())).data;
      data.rows.sort((a, b) => sortExamByTime(a, b));
    } catch (e) {
      failed = true;
    } finally {
      setBusyState(false);
    }
  }

  JwExamRows getNextExam() {
    for (JwExamRows exam in data.rows) {
      final examTime =
          exam.examTask.beginDate.substring(0, 11) + exam.examTask.beginTime;

      if (DateTime.parse(examTime).isAfter(DateTime.now())) {
        return exam;
      }
    }

    return null;
  }
}
