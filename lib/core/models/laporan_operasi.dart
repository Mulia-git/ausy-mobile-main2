class LaporanOperasi {
  final String tanggal;
  final String preOp;
  final String postOp;
  final String jaringan;
  final String selesai;
  final String pa;
  final String laporan;

  LaporanOperasi.fromJson(Map<String, dynamic> j)
      : tanggal = j['tanggal'],
        preOp = j['diagnosa_preop'],
        postOp = j['diagnosa_postop'],
        jaringan = j['jaringan_dieksekusi'],
        selesai = j['selesaioperasi'],
        pa = j['permintaan_pa'],
        laporan = j['laporan_operasi'];
}
