class Obat {
  final String tanggal;
  final String jam;
  final String kode;
  final String nama;
  final String jumlah;
  final String satuan;
  final String aturan;

  Obat.fromJson(Map<String, dynamic> json)
      : tanggal = json['tgl_perawatan'] ?? '',
        jam = json['jam'] ?? '',
        kode = json['kode_brng'] ?? '',
        nama = json['nama_brng'] ?? '',
        jumlah = json['jml'].toString(),
        satuan = json['kode_sat'] ?? '',
        aturan = json['aturan'] ?? '';
}
