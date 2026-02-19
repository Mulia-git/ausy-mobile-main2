import 'package:ausy/core/models/polyclinic.dart';
import 'package:ausy/core/services/polyclinic_service.dart';
import 'package:get/get.dart';

class PolyClinicController extends GetxController {
  // List dokter dari API
  var polyclinics = <Polyclinic>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Tanggal terpilih
  RxString date = ''.obs;

  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  // Filter shift waktu (Semua, Pagi, Sore, Malam)
  RxString selectedCategory = 'Semua'.obs;

  final PolyclinicService _polyclinicService = PolyclinicService();

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadPolyclinics() async {
    isLoading.value = true;
    polyclinics.value = await _polyclinicService.fetchPolyclinics();
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
  List<Polyclinic> get filteredPolyclinics {
    List<Polyclinic> list = polyclinics;
    // Filter shift waktu
    if (selectedCategory.value != 'Semua') {
      list = list.where((d) {
        switch (selectedCategory.value) {
          case 'Mata':
            return d.name.toLowerCase().contains("mata");
          case 'Umum':
            return d.name.toLowerCase().contains("umum");
          case 'Obgyn':
            return d.name.toLowerCase().contains("obgyn");
          case 'Jantung':
            return d.name.toLowerCase().contains("jantung");
          case 'Bedah':
            return d.name.toLowerCase().contains("bedah");
          case 'Saraf':
            return d.name.toLowerCase().contains("saraf");
          case 'Homecare':
            return d.name.toLowerCase().contains("Homecare");
          default:
            return true;
        }
      }).toList();
    }

    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((polyclinic) {
        final query = searchQuery.value.toLowerCase();
        return polyclinic.name.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}
