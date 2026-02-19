class Notification {
  final String id;
  final String judul;
  final String pesan;
  final String tipe;
  final String url;

  Notification({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.url,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      judul: json['judul'] ?? '',
      pesan: json['pesan'] ?? '',
      tipe: json['tipe'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
