class Available {
  final String available;
  final String className;
  final String booked;
  final String total;
  final List<String> images;
  final String description;

  Available({
    required this.available,
    required this.className,
    required this.booked,
    required this.total,
    required this.images,
    required this.description
  });

  factory Available.fromJson(Map<String, dynamic> json) {
    return Available(
      available: json['kosong'] ?? "0",
      className: json['kelas'] ?? "",
      booked: json['isi'] ?? "0",
      total: json['total'] ?? "0",
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      description: json['description'] ?? "",
    );
  }

  static List<Available> fromJsonList(List<dynamic> list) =>
      list.map((e) => Available.fromJson(e)).toList();
}