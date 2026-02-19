class Prosedur {
  final String kode;
  final String nama;
  final String status;

  Prosedur({
    required this.kode,
    required this.nama,
    required this.status,
  });

  factory Prosedur.fromJson(Map<String, dynamic> json) {
    return Prosedur(
      kode: json['kode'] ?? '-',
      nama: json['nama'] ?? '-',
      status: json['status'] ?? '-',
    );
  }
}
