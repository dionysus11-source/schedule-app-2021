class Plan {
  String title;
  String date;
  int time;
  String category;
  int id;
  Plan({this.title, this.date, this.time, this.category, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'category': category
    };
  }

  static String makeDate(int year, int month, int day) {
    return year.toString() +
        (month < 10 ? '0' + month.toString() : month.toString()) +
        (day < 10 ? '0' + day.toString() : day.toString());
  }
}
