class Outpatient {
  final String code;
  final String date;
  final String polyclinic;
  final String doctor;
  final String payment;

  Outpatient({
    required this.code,
    required this.date,
    required this.polyclinic,
    required this.doctor,
    required this.payment,
  });

  factory Outpatient.fromJson(Map<String, dynamic> json) {
    return Outpatient(
      code: json['no_rawat'] ?? '',
      date: json['tgl_registrasi'] ?? '',
      polyclinic: json['nm_poli'] ?? '',
      doctor: json['nm_dokter'] ?? '',
      payment: json['png_jawab'] ?? '',
    );
  }

  static List<Outpatient> fromJsonList(List list) =>
      list.map((e) => Outpatient.fromJson(e)).toList();
}
