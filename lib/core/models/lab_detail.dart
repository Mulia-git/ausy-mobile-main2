class LabDetail {
  final String nama;
  final String nilai;
  final String satuan;
  final String rujukan;
  final String flag;

  LabDetail.fromJson(Map<String, dynamic> j)
      : nama = j['Pemeriksaan'] ?? '',
        nilai = j['nilai'] ?? '',
        satuan = j['satuan'] ?? '',
        rujukan = j['nilai_rujukan'] ?? '',
        flag = j['keterangan'] ?? '';
}
