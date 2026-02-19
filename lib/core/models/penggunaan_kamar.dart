class PenggunaanKamar {
  final String masuk;
  final String keluar;
  final String kamar;
  final String status;
  final String lama;
  final double biaya;

  PenggunaanKamar.fromJson(Map<String, dynamic> j)
      : masuk = j['tgl_masuk'] + " " + j['jam_masuk'],
        keluar = j['tgl_keluar'] + " " + j['jam_keluar'],
        kamar = "${j['kd_kamar']} - ${j['nm_bangsal']}",
        status = j['stts_pulang'],
        lama = j['lama'],
        biaya = double.tryParse(j['ttl_biaya'].toString()) ?? 0;
}
