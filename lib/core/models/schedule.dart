class Schedule {
  final String code;
  final String name;
  final String start;
  final String finish;

  Schedule({
    required this.code,
    required this.name,
    required this.start,
    required this.finish
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      code: json['kd_poli'],
      name: json['nm_poli'],
      start: json['jam_mulai'],
      finish: json['jam_selesai']
    );
  }
  static List<Schedule> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Schedule.fromJson(json)).toList();
  }
}
