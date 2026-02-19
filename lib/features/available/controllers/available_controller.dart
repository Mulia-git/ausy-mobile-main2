import 'package:ausy/core/models/available.dart';
import 'package:ausy/core/services/available_service.dart';
import 'package:get/get.dart';

class AvailableController extends GetxController {
  // List dokter dari API
  var availables = <Available>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;
  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  final AvailableService _availableService = AvailableService();

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadRooms() async {
    isLoading.value = true;
    availables.value = await _availableService.fetchRooms();
    isLoading.value = false;
  }

  // Ganti teks pencarian
  void changeQuery(String query) {
    searchQuery.value = query;
  }

  // Daftar dokter hasil filter
  List<Available> get filteredAvailables {
    List<Available> list = availables;

    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((room) {
        final query = searchQuery.value.toLowerCase();
        return room.className.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}
