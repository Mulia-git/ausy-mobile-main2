class Telemedicine {
  final String doctor;
  final String gender;
  final String polyclinic;
  final String start;
  final String finish;

  Telemedicine({
    required this.doctor,
    required this.gender,
    required this.polyclinic,
    required this.start,
    required this.finish,
  });

  factory Telemedicine.fromJson(Map<String, dynamic> json) {
    return Telemedicine(
      doctor: json['nm_dokter']??"",
      gender: json['jk']??"",
      polyclinic: json['nm_poli']??"",
      start: json['jam_mulai']??"",
      finish: json['jam_selesai']??"",  
    );
  }
  static List<Telemedicine> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Telemedicine.fromJson(json)).toList();
  }
}
