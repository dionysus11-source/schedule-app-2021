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
}
