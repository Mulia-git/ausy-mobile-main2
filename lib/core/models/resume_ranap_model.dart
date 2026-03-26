class ResumeRanapModel {
  final String dokter;
  final String diagnosaAwal;
  final String alasan;

  final String keluhanUtama;
  final String pemeriksaanFisik;
  final String riwayatPenyakit;

  final String pemeriksaanPenunjang;
  final String hasilLaborat;

  final String tindakan;
  final String obatDiRs;

  final String diagnosaUtama;
  final List<String> diagnosaSekunder;

  final String prosedurUtama;
  final List<String> prosedurSekunder;

  final String edukasi;
  final String kondisi;
  final String caraKeluar;
  final String kontrol;

  final String obatPulang;

  ResumeRanapModel({
    required this.dokter,
    required this.diagnosaAwal,
    required this.alasan,
    required this.keluhanUtama,
    required this.pemeriksaanFisik,
    required this.riwayatPenyakit,
    required this.pemeriksaanPenunjang,
    required this.hasilLaborat,
    required this.tindakan,
    required this.obatDiRs,
    required this.diagnosaUtama,
    required this.diagnosaSekunder,
    required this.prosedurUtama,
    required this.prosedurSekunder,
    required this.edukasi,
    required this.kondisi,
    required this.caraKeluar,
    required this.kontrol,
    required this.obatPulang,
  });

  factory ResumeRanapModel.fromJson(Map<String, dynamic> json) {
    final d = json['diagnosa'] ?? {};
    final p = json['prosedur'] ?? {};

    return ResumeRanapModel(
      dokter: json['dokter'] ?? '',
      diagnosaAwal: json['diagnosa_awal'] ?? '',
      alasan: json['alasan'] ?? '',

      keluhanUtama: json['keluhan_utama'] ?? '',
      pemeriksaanFisik: json['pemeriksaan_fisik'] ?? '',
      riwayatPenyakit: json['riwayat_penyakit'] ?? '',

      pemeriksaanPenunjang: json['pemeriksaan_penunjang'] ?? '',
      hasilLaborat: json['hasil_laborat'] ?? '',

      tindakan: json['tindakan'] ?? '',
      obatDiRs: json['obat_di_rs'] ?? '',

      diagnosaUtama: d['utama'] ?? '',
      diagnosaSekunder: List<String>.from(d['sekunder'] ?? []),

      prosedurUtama: p['utama'] ?? '',
      prosedurSekunder: List<String>.from(p['sekunder'] ?? []),

      edukasi: json['edukasi'] ?? '',
      kondisi: json['keadaan'] ?? '',
      caraKeluar: json['cara_keluar'] ?? '',
      kontrol: json['kontrol'] ?? '',

      obatPulang: json['obat_pulang'] ?? '',
    );
  }
}