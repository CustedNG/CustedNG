import 'dart:async';
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

  Timer _updateTimer;

  Future<void> init() async {
    show = await CustedService().getShouldShowExam();

    if (!show) {
      return;
    }

    setBusyState(true);

    try {
      await refreshData();
      startAutoRefresh();
    } catch (e) {
      failed = true;
    } finally {
      setBusyState(false);
    }
  }

  JwExamRows getNextExam() {
    if (data == null) {
      return null;
    }
    
    for (JwExamRows exam in data.rows) {
      final examTime =
          exam.examTask.beginDate.substring(0, 11) + exam.examTask.beginTime;

      if (DateTime.parse(examTime).isAfter(DateTime.now())) {
        return exam;
      }
    }

    return null;
  }

  void refreshData() async {
    data = JwExam.fromJson(json.decode(await JwService().getExam())).data;
    data.rows.sort((a, b) => sortExamByTime(a, b));
  }

  void startAutoRefresh() {
    if (_updateTimer != null && _updateTimer.isActive) {
      return;
    }

    _updateTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      await refreshData();
      notifyListeners();
    });
  }
}
