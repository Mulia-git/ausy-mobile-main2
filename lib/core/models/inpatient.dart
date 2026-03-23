class Inpatient {
  final String code;
  final String doctor;
  final String polyclinic;
  final String insurance;
  final String registerDate;

  final String? dischargeDate;
  final String? room;
  final String? className;
  final String? lama;

  Inpatient({
    required this.code,
    required this.doctor,
    required this.polyclinic,
    required this.insurance,
    required this.registerDate,
    this.dischargeDate,
    this.room,
    this.className, this.lama,
  });

  factory Inpatient.fromJson(Map<String, dynamic> json) {
    return Inpatient(
      code: json['no_rawat'] ?? '',
      doctor: json['nm_dokter'] ?? '',
      polyclinic: json['nm_bangsal'] ?? '',
      insurance: json['png_jawab'] ?? '',
      registerDate: json['tgl_masuk'] ?? '',

      dischargeDate: json['tgl_keluar'],
      room: json['nm_bangsal'],
      className: json['kelas'],
      lama: json['lama'],
    );
  }
  static List<Inpatient> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Inpatient.fromJson(json)).toList();
  }
}