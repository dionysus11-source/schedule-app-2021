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
      'type': type, // 목표, 시간
      'year': year,
      'cnt': cnt
    };
  }
}
