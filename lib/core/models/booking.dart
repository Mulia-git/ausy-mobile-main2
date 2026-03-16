class Booking {
  final String code;
  final String doctor;
  final String polyclinic;
  final String insurance;
  final String status;
  final String registerDate;
  final String checkDate;

  final String kdPoli;
  final String kdDokter;
  final String noRkmMedis;

  Booking({
    required this.code,
    required this.doctor,
    required this.polyclinic,
    required this.insurance,
    required this.status,
    required this.registerDate,
    required this.checkDate,
    required this.kdPoli,
    required this.kdDokter,
    required this.noRkmMedis,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      code: json['no_reg'] ?? '',
      doctor: json['nm_dokter'] ?? '',
      polyclinic: json['nm_poli'] ?? '',
      insurance: json['png_jawab'] ?? '',
      status: json['status'] ?? '',
      registerDate: json['tanggal_booking'] ?? '',
      checkDate: json['tanggal_periksa'] ?? '',
      kdPoli: json['kd_poli'] ?? '',
      kdDokter: json['kd_dokter'] ?? '',
      noRkmMedis: json['no_rkm_medis'] ?? '',
    );
  }

  static List<Booking> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Booking.fromJson(json)).toList();
  }
}