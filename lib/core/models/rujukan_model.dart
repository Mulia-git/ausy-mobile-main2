class Rujukan {
  final String asal;
  final String tanggal;
  final String noRujukan;
  final String ppk;

  Rujukan({
    required this.asal,
    required this.tanggal,
    required this.noRujukan,
    required this.ppk,
  });

  factory Rujukan.fromJson(Map<String, dynamic> json) {
    return Rujukan(
      asal: json['asal'] ?? '-',
      tanggal: json['tgl'] ?? '-',
      noRujukan: json['no_rujukan'] ?? '-',
      ppk: json['ppk'] ?? '-',
    );
  }
}
