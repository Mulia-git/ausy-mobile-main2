import 'lab_detail.dart';

class LabItem {
  final String kode;
  final String nama;
  final String tanggal;
  final String jam;
  final List<LabDetail> details;

  LabItem({
    required this.kode,
    required this.nama,
    required this.tanggal,
    required this.jam,
    required this.details,
  });
}
