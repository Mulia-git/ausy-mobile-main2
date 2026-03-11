class SuratSakit {

  final String noSurat;
  final String pdfUrl;

  SuratSakit({
    required this.noSurat,
    required this.pdfUrl,
  });

  factory SuratSakit.fromJson(Map<String,dynamic> json){

    return SuratSakit(
      noSurat: json['no_surat'],
      pdfUrl: json['pdf_url'],
    );
  }
}