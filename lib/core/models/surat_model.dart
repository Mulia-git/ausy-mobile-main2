class SuratKeterangan {
  final String noSurat;
  final String noRawat;
  final String tanggalSurat;
  final String pdfUrl;

  SuratKeterangan({
    required this.noSurat,
    required this.noRawat,
    required this.tanggalSurat,
    required this.pdfUrl,
  });

  factory SuratKeterangan.fromJson(Map<String, dynamic> json) {
    return SuratKeterangan(
      noSurat: json['no_surat'] ?? '',
      noRawat: json['no_rawat'] ?? '',
      tanggalSurat: json['tanggalsurat'] ?? '',
      pdfUrl: json['pdf_url'] ?? '',
    );
  }
}