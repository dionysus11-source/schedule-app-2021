class TimeTracker {
  int type;
  int goalTime;
  int spentTime;
  String reason;
  String improvement;
  int week;
  int year;
  int id;

  TimeTracker(
      {this.type,
      this.goalTime,
      this.reason,
      this.improvement,
      this.id,
      this.week,
      this.year});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'goalTime': goalTime,
      'reason': reason,
      'improvement': improvement,
      'id': id,
      'week': week, // 목표, 시간
      'year': year,
    };
  }
}
