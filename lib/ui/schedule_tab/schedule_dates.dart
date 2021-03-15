class ScheduleDates {
  static final solarTerms = {
    DateTime(2021, 2, 3): '立春',
    DateTime(2021, 2, 18): '雨水',
    DateTime(2021, 3, 5): '惊蛰',
    DateTime(2021, 3, 20): '春分',
    DateTime(2021, 4, 4): '清明',
    DateTime(2021, 4, 20): '谷雨',
    DateTime(2021, 5, 5): '立夏',
    DateTime(2021, 5, 21): '小满',
    DateTime(2021, 6, 5): '芒种',
    DateTime(2021, 6, 21): '夏至',
    DateTime(2021, 7, 7): '小暑',
    DateTime(2021, 7, 22): '大暑',
    DateTime(2021, 8, 7): '立秋',
    DateTime(2021, 8, 23): '处暑',
    DateTime(2021, 9, 7): '白露',
    DateTime(2021, 9, 23): '秋分',
    DateTime(2021, 10, 8): '寒露',
    DateTime(2021, 10, 23): '霜降',
    DateTime(2021, 11, 7): '立冬',
    DateTime(2021, 11, 22): '小雪',
    DateTime(2021, 12, 7): '大雪',
    DateTime(2021, 12, 21): '冬至',
    DateTime(2022, 1, 5): '小寒',
    DateTime(2022, 1, 20): '大寒',
  };

  static String getSolarTerm(DateTime dateTime) {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return solarTerms[dateTime];
  }

  static final holidays = {
    DateTime(2020, 4, 4): '清明',
    DateTime(2020, 4, 5): '休',
    DateTime(2020, 4, 6): '休',

    DateTime(2020, 4, 26): '班',
    DateTime(2020, 5, 1): '劳动节',
    DateTime(2020, 5, 2): '休',
    DateTime(2020, 5, 3): '休',
    DateTime(2020, 5, 4): '休',
    DateTime(2020, 5, 5): '休',
    DateTime(2020, 5, 9): '班',

    DateTime(2020, 6, 25): '端午',
    DateTime(2020, 6, 26): '休',
    DateTime(2020, 6, 27): '休',
    DateTime(2020, 6, 28): '班',

    DateTime(2020, 9, 10): '教师节',

    DateTime(2020, 10, 1): '中秋国庆',
    DateTime(2020, 10, 2): '休',
    DateTime(2020, 10, 3): '周四课',
    DateTime(2020, 10, 4): '周五课',

    /***  2021 ***/

    DateTime(2021, 1, 1): '元旦',
    DateTime(2021, 1, 2): '休',
    DateTime(2021, 1, 3): '休',

    DateTime(2021, 4, 3): '休',
    DateTime(2021, 4, 4): '清明',
    DateTime(2021, 4, 5): '休',

    DateTime(2021, 4, 25): '周一课',
    DateTime(2021, 5, 1): '劳动节',
    DateTime(2021, 5, 2): '休',
    DateTime(2021, 5, 3): '休',
    DateTime(2021, 5, 4): '休',
    DateTime(2021, 5, 5): '休',
    DateTime(2021, 5, 8): '周二课',

    DateTime(2021, 6, 12): '休',
    DateTime(2021, 6, 13): '休',
    DateTime(2021, 6, 14): '端午',

    DateTime(2021, 7, 19): '暑假',

    // DateTime(2021, 9, 10): '教师节',
  };

  static String getHoliday(DateTime dateTime) {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return holidays[dateTime];
  }
}
