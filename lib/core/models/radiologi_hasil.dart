class RadiologiHasil {
  final String tanggal;
  final String jam;
  final String hasil;

  RadiologiHasil.fromJson(Map<String, dynamic> j)
      : tanggal = j['tgl_periksa'],
        jam = j['jam'],
        hasil = j['hasil'];
}
