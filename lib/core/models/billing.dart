class Billing {
  final String code;
  final String doctor;
  final String polyclinic;
  final String date;
  final String total;

  Billing({
    required this.code,
    required this.doctor,
    required this.polyclinic,
    required this.date,
    required this.total
  });

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      code: json['kd_billing'],
      doctor: json['nm_dokter'],
      polyclinic: json['nm_poli'],
      date: json['tgl_registrasi'],
      total: json['total_bayar'],  
    );
  }
  static List<Billing> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Billing.fromJson(json)).toList();
  }
}
