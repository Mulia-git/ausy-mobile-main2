import 'operasi_tim.dart';

class OperasiItem {
  final String tanggal;
  final String kode;
  final String nama;
  final String anastesi;
  final double total;
  final List<OperasiTim> tim;

  OperasiItem.fromJson(Map<String, dynamic> j)
      : tanggal = j['tgl_operasi'],
        kode = j['kode_paket'],
        nama = j['nm_perawatan'],
        anastesi = j['jenis_anasthesi'],
        total = double.tryParse(j['total'].toString()) ?? 0,
        tim = (j['tim'] as List? ?? [])
            .map((e) => OperasiTim(e['peran'], e['nama']))
            .toList();
}
