class Polyclinic {
  final String code;
  final String name;
  final String price;
  final String priceFormat;
  final String status;

  Polyclinic({
    required this.code,
    required this.name,
    required this.price,
    required this.priceFormat,
    required this.status,
  });

  factory Polyclinic.fromJson(Map<String, dynamic> json) {
    return Polyclinic(
      code: json['kd_poli'],
      name: json['nm_poli'],
      price: json['registrasilama'],
      priceFormat: json['registrasi'],
      status: json['status'],
    );
  }
  static List<Polyclinic> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Polyclinic.fromJson(json)).toList();
  }
}
