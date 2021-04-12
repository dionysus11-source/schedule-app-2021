class WeeklyFeedback {
  String goal;
  String result;
  String reason;
  String todo;
  int week;
  int year;
  int id;
  WeeklyFeedback(
      {this.goal,
      this.result,
      this.reason,
      this.todo,
      this.week,
      this.year,
      this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal': goal,
      'result': result,
      'reason': reason,
      'todo': todo,
      'week': week,
      'year': year
    };
  }
}
