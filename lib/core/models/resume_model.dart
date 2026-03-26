class ResumeModel {
  final String dokter;
  final String keluhanUtama;
  final String riwayatPenyakit;
  final String pemeriksaanPenunjang;
  final String hasilLaborat;
  final String kondisiPulang;
  final String obatPulang;

  final String diagnosaUtama;
  final String kodeDiagnosaUtama;
  final List<String> diagnosaSekunder;

  final String prosedurUtama;
  final String kodeProsedurUtama;
  final List<String> prosedurSekunder;

  ResumeModel({
    required this.dokter,
    required this.keluhanUtama,
    required this.riwayatPenyakit,
    required this.pemeriksaanPenunjang,
    required this.hasilLaborat,
    required this.kondisiPulang,
    required this.obatPulang,
    required this.diagnosaUtama,
    required this.kodeDiagnosaUtama,
    required this.diagnosaSekunder,
    required this.prosedurUtama,
    required this.kodeProsedurUtama,
    required this.prosedurSekunder,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    final d = json['diagnosa'] ?? {};
    final p = json['prosedur'] ?? {};

    return ResumeModel(
      dokter: json['dokter'] ?? '',
      keluhanUtama: json['keluhan_utama'] ?? '',
      riwayatPenyakit: json['riwayat_penyakit'] ?? '',
      pemeriksaanPenunjang: json['pemeriksaan_penunjang'] ?? '',
      hasilLaborat: json['hasil_laborat'] ?? '',
      kondisiPulang: json['kondisi_pulang'] ?? '',
      obatPulang: json['obat_pulang'] ?? '',

      diagnosaUtama: d['utama'] ?? '',
      kodeDiagnosaUtama: d['kode_utama'] ?? '',
      diagnosaSekunder: (d['sekunder'] is List)
        ? List<String>.from(d['sekunder'])
        : [],

      prosedurUtama: p['utama'] ?? '',
      kodeProsedurUtama: p['kode_utama'] ?? '',
      prosedurSekunder: List<String>.from(p['sekunder'] ?? []),
    );
  }
}