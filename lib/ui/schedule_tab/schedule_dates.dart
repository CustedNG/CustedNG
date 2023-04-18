class ScheduleDates {
  static final holidays = {
    /*
    2023
    经国务院批准，现将2023年元旦、春节、清明节、劳动节、端午节、中秋节和国庆节放假调休日期的具体安排通知如下。
一、元旦：2022年12月31日至2023年1月2日放假调休，共3天。
二、春节：1月21日至27日放假调休，共7天。1月28日（星期六）、1月29日（星期日）上班。
三、清明节：4月5日放假，共1天。
四、劳动节：4月29日至5月3日放假调休，共5天。4月23日（星期日）、5月6日（星期六）上班。
五、端午节：6月22日至24日放假调休，共3天。6月25日（星期日）上班。
六、中秋节、国庆节：9月29日至10月6日放假调休，共8天。10月7日（星期六）、10月8日（星期日）上班。
    */
    DateTime(2023, 4, 5): '清明',
    DateTime(2023, 4, 29): '休',
    DateTime(2023, 4, 30): '休',
    DateTime(2023, 5, 1): '劳动',
    DateTime(2023, 5, 2): '休',
    DateTime(2023, 5, 2): '休',
    DateTime(2023, 4, 23): '班',
    DateTime(2023, 5, 6): '班',
    DateTime(2023, 6, 22): '端午',
    DateTime(2023, 6, 23): '休',
    DateTime(2023, 6, 24): '休',
    DateTime(2023, 6, 25): '班',
    DateTime(2023, 9, 29): '中秋',
    DateTime(2023, 9, 30): '休',
    DateTime(2023, 10, 1): '国庆',
    DateTime(2023, 10, 2): '休',
    DateTime(2023, 10, 3): '休',
    DateTime(2023, 10, 4): '休',
    DateTime(2023, 10, 5): '休',
    DateTime(2023, 10, 6): '休',
    DateTime(2023, 10, 7): '班',
    DateTime(2023, 10, 8): '班',
  };

  static String getHoliday(DateTime dateTime) {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return holidays[dateTime];
  }
}
