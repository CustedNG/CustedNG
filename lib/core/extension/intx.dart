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

  Duration get days {
    return Duration(days: this);
  }

  String withSizeUnit() {
    const units = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    var number = this.toDouble();
    var unitIndex = 0;
    while (number >= 1024 && unitIndex < units.length) {
      number /= 1024;
      unitIndex++;
    }
    return number.toStringAsFixed(1) + ' ' + units[unitIndex];
  }
}
