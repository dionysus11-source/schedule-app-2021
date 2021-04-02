class DailyFeedback {
  String review;
  String date;
  String todo;
  String diary;
  int id;
  DailyFeedback({this.review, this.date, this.todo, this.diary, this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'review': review,
      'date': date,
      'todo': todo,
      'diary': diary,
    };
  }
}
