class Inpatient {
  final String code;
  final String doctor;
  final String polyclinic;
  final String insurance;
  final String registerDate;

  Inpatient({
    required this.code,
    required this.doctor,
    required this.polyclinic,
    required this.insurance,
    required this.registerDate,
  });

  factory Inpatient.fromJson(Map<String, dynamic> json) {
    return Inpatient(
      code: json['no_rawat']??"",
      doctor: json['nm_dokter']??"",
      polyclinic: json['nm_poli']??"",
      insurance: json['png_jawab']??"",
      registerDate: json['tgl_registrasi']??"",  
    );
  }
  static List<Inpatient> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Inpatient.fromJson(json)).toList();
  }
}
