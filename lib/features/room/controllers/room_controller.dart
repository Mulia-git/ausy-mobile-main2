import 'package:ausy/core/models/room.dart';
import 'package:ausy/core/services/room_service.dart';
import 'package:get/get.dart';

class RoomController extends GetxController {
  // List dokter dari API
  var rooms = <Room>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Tanggal terpilih
  RxString date = ''.obs;

  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  // Filter shift waktu (Semua, Pagi, Sore, Malam)
  RxString selectedCategory = 'Semua'.obs;

  final RoomService _roomService = RoomService();

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadRooms() async {
    isLoading.value = true;
    rooms.value = await _roomService.fetchRooms();
    isLoading.value = false;
  }

  // Ganti teks pencarian
  void changeQuery(String query) {
    searchQuery.value = query;
  }

  // Ganti shift (Pagi/Sore/Malam)
  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // Daftar dokter hasil filter
  List<Room> get filteredRooms {
    List<Room> list = rooms;
    // Filter shift waktu
    if (selectedCategory.value != 'Semua') {
      list = list.where((d) {
        switch (selectedCategory.value) {
          case 'ICU':
            return d.wardName.toLowerCase().contains("icu");
          case 'Anak':
            return d.wardName.toLowerCase().contains("anak");
          case 'Dewasa':
            return d.wardName.toLowerCase().contains("dewasa");
          case 'Perinatologi':
            return d.wardName.toLowerCase().contains("perinatologi");
          case 'Nifas':
            return d.wardName.toLowerCase().contains("nifas");
          case 'Kelas 1':
            return d.roomClass.toLowerCase().contains("kelas 1");
          case 'Kelas 2':
            return d.roomClass.toLowerCase().contains("kelas 2");
          case 'Kelas 3':
            return d.roomClass.toLowerCase().contains("kelas 3");
          case 'VIP':
            return d.roomClass.toLowerCase().contains("kelas vip");
          default:
            return true;
        }
      }).toList();
    }

    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((room) {
        final query = searchQuery.value.toLowerCase();
        return room.wardName.toLowerCase().contains(query) || room.roomCode.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}
