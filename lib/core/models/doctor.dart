class Doctor {
  final String code;
  final String name;
  final String polyCode;
  final String polyclinic;
  final String start;
  final String end;
  final String gender;
  final String photo;

  Doctor({
    required this.code,
    required this.name,
    required this.polyCode,
    required this.polyclinic,
    required this.start,
    required this.end,
    required this.gender,
    required this.photo,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      code: json['kd_dokter'] ?? '',
      name: json['nm_dokter'] ?? '',
      polyCode: json['kd_poli'] ?? '',
      polyclinic: json['nm_poli'] ?? '',
      start: json['jam_mulai'] ?? '',
      end: json['jam_selesai'] ?? '',
      gender: json['jk'] ?? 'L',
      photo: json['photo'] ?? '',
    );
  }

  static List<Doctor> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Doctor.fromJson(json)).toList();
  }
}
