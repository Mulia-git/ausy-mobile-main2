import 'package:ausy/core/models/telemedicine.dart';
import 'package:ausy/core/services/telemedicine_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TelemedicineController extends GetxController {
  // List dokter dari API
  var telemedicines = <Telemedicine>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Tanggal terpilih
  RxString date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  // Filter shift waktu (Semua, Pagi, Sore, Malam)
  RxString selectedShift = 'Semua'.obs;

  final TelemedicineService _telemedicineService = TelemedicineService();

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadTelemedicines() async {
    isLoading.value = true;
    telemedicines.value = await _telemedicineService.fetchTelemedicines(date.value);
    isLoading.value = false;
  }

  // Set tanggal dan muat data
  void setSelectedDate(String selectedDate) {
    date.value = selectedDate;
    loadTelemedicines();
  }

  // Ganti teks pencarian
  void changeQuery(String query) {
    searchQuery.value = query;
  }

  // Ganti shift (Pagi/Sore/Malam)
  void changeShift(String shift) {
    selectedShift.value = shift;
  }

  // Daftar dokter hasil filter
  List<Telemedicine> get filteredTelemedicines {
    List<Telemedicine> list = telemedicines;
    // Filter shift waktu
    if (selectedShift.value != 'Semua') {
      list = list.where((d) {
        final startHour = int.tryParse(d.start.split(":")[0]) ?? 0;

        switch (selectedShift.value) {
          case 'Pagi':
            return startHour >= 5 && startHour < 12;
          case 'Sore':
            return startHour >= 12 && startHour < 18;
          case 'Malam':
            return startHour >= 18 && startHour < 24;
          default:
            return true;
        }
      }).toList();
    }

    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((doctor) {
        final query = searchQuery.value.toLowerCase();
        return doctor.doctor.toLowerCase().contains(query) ||
            doctor.polyclinic.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}
