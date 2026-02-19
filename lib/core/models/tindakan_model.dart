class Tindakan {
  final String tanggal;
  final String jam;
  final String kode;
  final String nama;
  final String pelaksana;
  final String tipe;

  Tindakan.fromJson(Map<String, dynamic> json)
      : tanggal = json['tgl_perawatan'] ?? '',
        jam = json['jam_rawat'] ?? '',
        kode = json['kd_jenis_prw'] ?? '',
        nama = json['nm_perawatan'] ?? '',
        pelaksana = json['pelaksana'] ?? '',
        tipe = json['tipe'] ?? '';
}
