class RadiologiItem {
  final String tanggal;
  final String jam;
  final String kode;
  final String nama;
  final String dokter;
  final String petugas;
  final String proyeksi;
  final double biaya;

  RadiologiItem.fromJson(Map<String, dynamic> j)
      : tanggal = j['tgl_periksa'],
        jam = j['jam'],
        kode = j['kd_jenis_prw'],
        nama = j['nm_perawatan'],
        dokter = j['nm_dokter'],
        petugas = j['nama'],
        proyeksi = j['proyeksi'] ?? '',
        biaya = double.tryParse(j['biaya'].toString()) ?? 0;
}
