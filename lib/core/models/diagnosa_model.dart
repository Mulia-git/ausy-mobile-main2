class Diagnosa {
  final String kode;
  final String nama;
  final String status;

  Diagnosa({
    required this.kode,
    required this.nama,
    required this.status,
  });

  factory Diagnosa.fromJson(Map<String, dynamic> json) {
    return Diagnosa(
      kode: json['kode'] ?? '-',
      nama: json['nama'] ?? '-',
      status: json['status'] ?? '-',
    );
  }
}
