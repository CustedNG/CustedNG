extension IntX on int {

  String weekdayInChinese([String prefix = '星期']) {
    assert(this != null);
    assert(this >= 1);
    assert(this <= 7);
    final arr = '一二三四五六日';
    return "$prefix${arr[this - 1]}";
  }

  Duration get ms {
    return Duration(milliseconds: this);
  }

  Duration get seconds {
    return Duration(seconds: this);
  }
}