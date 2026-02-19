import 'operasi_item.dart';
import 'laporan_operasi.dart';

class OperasiModel {
  final List<OperasiItem> operasi;
  final List<LaporanOperasi> laporan;

  OperasiModel.fromJson(Map<String, dynamic> j)
      : operasi = (j['operasi'] as List? ?? [])
      .map((e) => OperasiItem.fromJson(e))
      .toList(),
        laporan = (j['laporan'] as List? ?? [])
            .map((e) => LaporanOperasi.fromJson(e))
            .toList();
}
