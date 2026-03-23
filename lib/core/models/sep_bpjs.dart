import 'package:ausy/core/models/rujukan_model.dart';

class SepBpjs {
  final String noSep;
  final String tglSep;
  final String noKartu;
  final String peserta;
  final String jenisPelayanan;
  final String kelasRawat;
  final String poli;
  final String diagnosa;
  final String dpjp;
  final Rujukan? rujukan;

  SepBpjs({
    required this.noSep,
    required this.tglSep,
    required this.noKartu,
    required this.peserta,
    required this.jenisPelayanan,
    required this.kelasRawat,
    required this.poli,
    required this.diagnosa,
    required this.dpjp,
    this.rujukan,
  });

  factory SepBpjs.fromJson(Map<String, dynamic> json) {
    final sep = json['sep'] ?? {};

    final pelayanan = sep['pelayanan'] ?? {};
    final rujukanJson = sep['rujukan'];

    return SepBpjs(
      noSep: sep['no_sep'] ?? '-',
      tglSep: sep['tgl_sep'] ?? '-',
      noKartu: sep['no_kartu'] ?? '-',
      peserta: sep['peserta'] ?? '-',

      /// 🔥 FIX NESTED
      jenisPelayanan: pelayanan['jenis'] ?? '-',
      kelasRawat: pelayanan['kelas'] ?? '-',

      poli: (sep['poli'] ?? '').toString().trim().isEmpty ? '-' : sep['poli'],
      diagnosa: sep['diagnosa'] ?? '-',
      dpjp: sep['dpjp'] ?? '-',

      rujukan:
      rujukanJson != null ? Rujukan.fromJson(rujukanJson) : null,
    );
  }
}