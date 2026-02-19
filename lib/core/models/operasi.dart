class Operasi {
  final String tanggal;
  final String paket;
  final String nama;
  final String anastesi;
  final double total;

  Operasi.fromJson(Map<String, dynamic> j)
      : tanggal = j['tgl_operasi'],
        paket = j['kode_paket'],
        nama = j['nm_perawatan'],
        anastesi = j['jenis_anasthesi'],
        total = double.tryParse(j['total'].toString()) ?? 0;
}
