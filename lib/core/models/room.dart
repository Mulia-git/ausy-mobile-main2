class Room {
  final String wardCode;
  final String roomCode;
  final String roomClass;
  final String wardName;
  final String status;
  final String roomRate;

  Room({
    required this.wardCode,
    required this.roomCode,
    required this.roomClass,
    required this.wardName,
    required this.status,
    required this.roomRate,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      wardCode: json['kd_bangsal'],
      roomCode: json['kd_kamar'],
      roomClass: json['kelas'],
      wardName: json['nm_bangsal'],
      status: json['status'],
      roomRate: json['trf_kamar'],
    );
  }

  static List<Room> fromJsonList(List<dynamic> list) =>
      list.map((e) => Room.fromJson(e)).toList();
}
