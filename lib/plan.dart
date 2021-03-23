class Plan {
  String title;
  String date;
  String time;
  String category;
  int id;
  Plan({this.title, this.date, this.time, this.id, this.category});

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
