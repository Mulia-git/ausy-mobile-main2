class TindakanRanapDokter {
  final String tanggal;
  final String jam;
  final String kode;
  final String nama;
  final String dokter;
  final double biaya;

  TindakanRanapDokter.fromJson(Map<String, dynamic> json)
      : tanggal = json['tgl_perawatan'] ?? '',
        jam = json['jam_rawat'] ?? '',
        kode = json['kd_jenis_prw'] ?? '',
        nama = json['nm_perawatan'] ?? '',
        dokter = json['nm_dokter'] ?? '',
        biaya = double.tryParse(json['biaya_rawat'].toString()) ?? 0;
}
