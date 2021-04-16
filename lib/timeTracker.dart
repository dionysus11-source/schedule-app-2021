class TimeTracker {
  int type;
  int goalTime;
  int spentTime;
  double _percentage;
  String reason;
  String improvement;
  int week;
  int year;
  int id;

  TimeTracker(
      {this.type,
      this.goalTime,
      this.spentTime,
      this.reason,
      this.improvement,
      this.id,
      this.week,
      this.year});
  get percentage {
    _percentage = (spentTime / goalTime) * 100;
    return _percentage.toInt();
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'goalTime': goalTime,
      'spentTime': spentTime,
      'reason': reason,
      'improvement': improvement,
      'id': id,
      'week': week, // 목표, 시간
      'year': year,
    };
  }
}
