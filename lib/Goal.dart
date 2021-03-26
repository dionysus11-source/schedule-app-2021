class Goal {
  int spirit;
  int intelligence;
  int social;
  int physical;
  int sleep;
  int trash;
  String type; // 주, 월
  int year;
  int cnt;
  int id;
  Goal(
      {this.spirit,
      this.intelligence,
      this.social,
      this.physical,
      this.sleep,
      this.trash,
      this.type,
      int year,
      int cnt});

  Map<String, dynamic> toMap() {
    return {
      'spirit': spirit,
      'intelligence': intelligence,
      'social': social,
      'physical': physical,
      'sleep': sleep,
      'trash': trash,
      'id': id,
      'type': type, // 주, 월
      'year': year,
      'cnt': cnt
    };
  }

  static bool isLeap(year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    if (year % 4 == 0) return true;
    return false;
  }

  static double pYear(double year) {
    return (year +
            (year / 4).floor() -
            (year / 100).floor() +
            (year / 400).floor()) %
        7;
  }

  static int lastWeek(double year) {
    if (pYear(year) == 4 || pYear(year - 1) == 3) return 53;
    return 52;
  }

  static int ordinalDay(date) {
    const List ordinal_table = [
      0,
      31,
      59,
      90,
      120,
      151,
      181,
      212,
      243,
      273,
      304,
      334
    ];

    if (isLeap(date.year.toDouble()))
      for (var i = 2; i < ordinal_table.length; i++) ordinal_table[i] += 1;

    return ordinal_table[date.month] + date.day;
  }

  static int getweekNumber(DateTime date) {
    var ordinal_day = ordinalDay(date);
    var current_year = date.year.toDouble();
    var weekday = date.weekday;
    var week = ((ordinal_day - weekday + 10) / 7).floor();

    if (week < 1) return lastWeek(current_year - 1);
    if (week > lastWeek(current_year)) return 1;
    return week;
  }
}
