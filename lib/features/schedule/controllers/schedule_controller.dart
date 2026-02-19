import 'package:ausy/core/models/schedule.dart';
import 'package:ausy/core/services/schedule_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleController extends GetxController {
  // List dokter dari API
  var schedules = <Schedule>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

   // Tanggal terpilih
  RxString date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  // Filter shift waktu (Semua, Pagi, Sore, Malam)
  RxString selectedShift = 'Semua'.obs;

  final ScheduleService _scheduleService = ScheduleService();

  // Ambil data dokter berdasarkan tanggal
 Future<void> loadSchedules() async {
  isLoading.value = true;

  final fetched = await _scheduleService.fetchSchedules(date.value);

  // Urutkan berdasarkan nama (A-Z)
  fetched.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  schedules.value = fetched;

  isLoading.value = false;
}

  // Ganti teks pencarian
  void changeQuery(String query) {
    searchQuery.value = query;
  }

  // Ganti shift (Pagi/Sore/Malam)
  void changeShift(String shift) {
    selectedShift.value = shift;
  }

   // Set tanggal dan muat data
  void setSelectedDate(String selectedDate) {
    date.value = selectedDate;
    loadSchedules();
  }

  // Daftar dokter hasil filter
  List<Schedule> get filteredSchedules{
    List<Schedule> list = schedules;
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
      list = list.where((schedule) {
        final query = searchQuery.value.toLowerCase();
        return schedule.name.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}
