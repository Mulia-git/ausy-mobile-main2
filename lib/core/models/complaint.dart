class Complaint {
  final String id;
  final String date;
  final String message;
  final String name;
  final String gender;

  Complaint({
    required this.id,
    required this.date,
    required this.message,
    required this.name,
    required this.gender,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id']??"",
      date: json['tanggal']??"",
      message: json['pesan']??"",
      name: json['nm_pasien']??"",
      gender: json['jk']??"",  
    );
  }
  static List<Complaint> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Complaint.fromJson(json)).toList();
  }
}
