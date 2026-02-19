import 'rujukan_model.dart';
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
    required this.dpjp,this.rujukan,

  });

  factory SepBpjs.fromJson(Map<String, dynamic> json,) {
    final sep = json['sep'];

    return SepBpjs(
      noSep: sep['no_sep'] ?? '',
      tglSep: sep['tgl_sep'] ?? '',
      noKartu: sep['no_kartu'] ?? '',
      peserta: sep['peserta'] ?? '',
      jenisPelayanan: sep['pelayanan']['jenis'] ?? '',
      kelasRawat: sep['pelayanan']['kelas'] ?? '',
      poli: sep['poli'] ?? '',
      diagnosa: sep['diagnosa'] ?? '',
      dpjp: sep['dpjp'] ?? '',
      rujukan: sep['rujukan'] != null
          ? Rujukan.fromJson(sep['rujukan'])
          : null,
    );
  }
}
class Rujukan {
  final String asal;
  final String tanggal;
  final String noRujukan;
  final String ppk;

  Rujukan({
    required this.asal,
    required this.tanggal,
    required this.noRujukan,
    required this.ppk,
  });

  factory Rujukan.fromJson(Map<String, dynamic> json) {
    return Rujukan(
      asal: json['asal'] ?? '-',
      tanggal: json['tgl'] ?? '-',
      noRujukan: json['no_rujukan'] ?? '-',
      ppk: json['ppk'] ?? '-',
    );
  }
}

