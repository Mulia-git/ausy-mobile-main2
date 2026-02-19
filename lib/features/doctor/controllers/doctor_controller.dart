import 'package:ausy/core/models/doctor.dart';
import 'package:ausy/core/services/booking_service.dart';
import 'package:ausy/core/services/doctor_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/models/booking.dart';

class DoctorController extends GetxController {
  // List dokter dari API
  var doctors = <Doctor>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Tanggal terpilih
  RxString date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  // Filter shift waktu (Semua, Pagi, Sore, Malam)
  RxString selectedShift = 'Semua'.obs;

  final DoctorService _doctorService = DoctorService();
  final BookingService _bookingService = BookingService();

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadDoctors() async {
    isLoading.value = true;
    doctors.value = await _doctorService.fetchDoctors(date.value);
    isLoading.value = false;
  }

  // Set tanggal dan muat data
  void setSelectedDate(String selectedDate) {
    date.value = selectedDate;


    searchQuery.value = '';
    selectedShift.value = 'Semua';

    loadDoctors();
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
  List<Doctor> get filteredDoctors {
    List<Doctor> list = doctors;
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

    if (searchQuery.value.isNotEmpty) {
      list = list.where((doctor) {
        final query = searchQuery.value.toLowerCase();
        return doctor.name.toLowerCase().contains(query) ||
            doctor.polyclinic.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
  Rx<Booking?> activeBooking = Rx<Booking?>(null);
  RxBool checkingBooking = false.obs;


}
