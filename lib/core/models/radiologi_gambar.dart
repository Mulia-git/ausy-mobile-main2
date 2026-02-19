class RadiologiGambar {
  final String tanggal;
  final String jam;
  final String url;

  RadiologiGambar.fromJson(Map<String, dynamic> j)
      : tanggal = j['tgl_periksa'],
        jam = j['jam'],
        url = j['url'];
}
