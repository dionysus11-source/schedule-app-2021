class DailyFeedback {
  String review;
  String date;
  String todo;
  String diary;
  int week;
  int weekday;
  int id;
  DailyFeedback(
      {this.review,
      this.date,
      this.todo,
      this.diary,
      this.week,
      this.weekday,
      this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'review': review,
      'date': date,
      'todo': todo,
      'diary': diary,
      'week': week,
      'weekday': weekday
    };
  }
}
