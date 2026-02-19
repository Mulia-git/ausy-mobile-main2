class Soap {
  final String tanggal;
  final String jam;
  final String petugas;
  final String jabatan;
  final String subjektif;
  final String objektif;
  final String asesmen;
  final String plan;
  final String instruksi;
  final String evaluasi;

  Soap({
    required this.tanggal,
    required this.jam,
    required this.petugas,
    required this.jabatan,
    required this.subjektif,
    required this.objektif,
    required this.asesmen,
    required this.plan,
    required this.instruksi,
    required this.evaluasi,
  });

  factory Soap.fromJson(Map<String, dynamic> json) {
    return Soap(
      tanggal: json['tanggal']?.toString() ?? '',
      jam: json['jam']?.toString() ?? '',
      petugas: json['petugas']?.toString() ?? '',
      jabatan: json['jabatan']?.toString() ?? '',
      subjektif: json['subjektif']?.toString() ?? '',
      objektif: json['objektif']?.toString() ?? '',
      asesmen: json['asesmen']?.toString() ?? '',
      plan: json['plan']?.toString() ?? '',
      instruksi: json['instruksi']?.toString() ?? '',
      evaluasi: json['evaluasi']?.toString() ?? '',
    );
  }

  static List<Soap> fromJsonList(List data) {
    return data.map((e) => Soap.fromJson(e)).toList();
  }
}
