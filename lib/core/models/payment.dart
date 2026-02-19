class Payment {
  final String code;
  final String name;

  Payment({
    required this.code,
    required this.name
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      code: json['kd_pj'],
      name: json['png_jawab']
    );
  }
  static List<Payment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Payment.fromJson(json)).toList();
  }
}
