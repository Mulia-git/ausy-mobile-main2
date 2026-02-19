class Booking {
  final String code;
  final String doctor;
  final String polyclinic;
  final String insurance;
  final String status;
  final String registerDate;
  final String checkDate;

  Booking({
    required this.code,
    required this.doctor,
    required this.polyclinic,
    required this.insurance,
    required this.status,
    required this.registerDate,
    required this.checkDate
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      code: json['no_reg'],
      doctor: json['nm_dokter'],
      polyclinic: json['nm_poli'],
      insurance: json['png_jawab'],
      status: json['status'],  
      registerDate: json['tanggal_booking'],  
      checkDate: json['tanggal_periksa'],  
    );
  }
  static List<Booking> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Booking.fromJson(json)).toList();
  }
}
