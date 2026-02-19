class Radiologi {
  final String tanggal;
  final String nama;
  final String dokter;
  final String petugas;
  final double biaya;

  Radiologi.fromJson(Map<String, dynamic> j)
      : tanggal = j['tgl_periksa'] + " " + j['jam'],
        nama = j['nm_perawatan'],
        dokter = j['nm_dokter'],
        petugas = j['nama'],
        biaya = double.tryParse(j['biaya'].toString()) ?? 0;
}
