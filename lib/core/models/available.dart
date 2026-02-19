class Available {
  final String available;
  final String className;
  final String booked;
  final String total;

  Available({
    required this.available,
    required this.className,
    required this.booked,
    required this.total,
  });

  factory Available.fromJson(Map<String, dynamic> json) {
    return Available(
      available: json['kosong'],
      className: json['kelas'],
      booked: json['isi'],
      total: json['total'],
    );
  }

  static List<Available> fromJsonList(List<dynamic> list) =>
      list.map((e) => Available.fromJson(e)).toList();
}
