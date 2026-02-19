import 'dart:convert';

import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/booking.dart';
import 'package:ausy/core/models/doctor.dart';
import 'package:ausy/core/services/booking_service.dart';
import 'package:ausy/core/services/dio_service.dart';
import 'package:ausy/core/services/doctor_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ausy/core/models/doctor.dart';
class BookController extends GetxController {
  final DioService dioService = DioService();
  final GetStorage storage = GetStorage();
  // List dokter dari API
  var doctors = <Doctor>[].obs;
  var booking = Rxn<Booking>();
  RxString selectedDoctorId = ''.obs;
  RxBool autoSelectDoctor = false.obs;
  RxBool hasActiveBooking = false.obs;
  Rxn<Booking> activeBooking = Rxn<Booking>();


  RxBool isLoading = false.obs;
  RxBool isLoadingDetail = false.obs;
  RxBool isLoadingSchedule = false.obs;
  Rxn<Doctor> selectedDoctor = Rxn<Doctor>();
  RxBool fromSchedule = false.obs;



  RxBool isCheckingBooking = false.obs;

  RxString date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  RxString poly = "".obs;


  final DoctorService _doctorService = DoctorService();
  final BookingService _bookingService = BookingService();

  void loadBookingDetail(String date, String code) async {
    isLoadingDetail.value = true;
    booking.value = await _bookingService.fetchBookingDetail(date, code);
    isLoadingDetail.value = false;
  }



  Future<void> checkActiveBooking() async {
    try {
      isCheckingBooking.value = true;

      final medicalRecord = storage.read('medicalRecord') ?? '';
      final booking = await _bookingService.fetchActiveBooking(medicalRecord);

      if (booking != null) {
        activeBooking.value = booking;
        hasActiveBooking.value = true;
      } else {
        activeBooking.value = null;
        hasActiveBooking.value = false;
      }
    } catch (e) {
      activeBooking.value = null;
      hasActiveBooking.value = false;
    } finally {
      isCheckingBooking.value = false; // 🔥 selesai loading
    }
  }



  Future<void> loadDoctors() async {
    isLoadingSchedule.value = true;

    final result =
    await _doctorService.fetchScheduleDoctors(date.value, poly.value);

    doctors.value = result;

    // 🔥 AUTO PILIH DOKTER JIKA DIPERLUKAN
    if (autoSelectDoctor.value &&
        selectedDoctorId.value.isEmpty &&
        doctors.isNotEmpty) {
      selectedDoctorId.value = doctors.first.code;
    }

    isLoadingSchedule.value = false;
  }

  // Set tanggal dan muat data
  void setSelectedDate(String selectedDate) {
    date.value = selectedDate;
    loadDoctors();
  }

  // Set tanggal dan muat data
  void setPoly(String selectedPoly) {
    poly.value = selectedPoly;
    loadDoctors();
  }
  void showTopSheet(String message) {
    if (Get.context == null) return;

    Get.generalDialog(
      barrierDismissible: false,
      barrierLabel: 'TopSheet',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, _, __) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> register({
    required String? date,
    required String? polyclinic,
    required String? doctor,
    required String? insurance,
  }) async {
    try {
      isLoading.value = true;

      final response = await dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'daftar',
          'tanggal': date,
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
          'kd_poli': polyclinic,
          'kd_dokter': doctor,
          'kd_pj': insurance
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.data);


        if (data['state'] == 'duplication') {
          showTopSheet(data['message'] ?? "Anda sudah memiliki pendaftaran aktif.");
          return;
        }

        if (data['state'] == 'limit' || data['state'] == 'limitt') {
          showTopSheet("Kuota pendaftaran terpenuhi. Silahkan pilih hari/tanggal lain.");
          return;
        }

        final success = await dioService.dio.post(
          ApiConstants.baseUrl,
          queryParameters: {
            'action': 'sukses',
            'no_rkm_medis': storage.read('medicalRecord') ?? '',
          },
        );

        if (success.statusCode == 200) {
          final List<dynamic> bookings = jsonDecode(success.data);
          Booking booking = Booking.fromJson(bookings[0]);

          if (Get.isDialogOpen ?? false) Get.back(closeOverlays: true);

          Get.offAndToNamed('/bookdetail', arguments: {
            'date': booking.checkDate,
            'code': booking.code,
            'fromRegister': true,
          });
        }
      }
    }

    on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        final int? statusCode = error.response?.statusCode;

        switch (statusCode) {
          case 401:
            showErrorDialog("Unauthorized access");
            break;
          case 403:
            showErrorDialog("Anda tidak memiliki akses.");
            break;
          case 404:
            showErrorDialog("Data tidak ditemukan.");
            break;
          case 500:
            showErrorDialog("Server bermasalah. Coba lagi nanti.");
            break;
          case 422:
            showErrorDialog("Data yang dikirim tidak valid.");
            break;
          default:
            showErrorDialog("Error kode: $statusCode");
        }
      } else {
        showErrorDialog("Gangguan jaringan. Periksa koneksi internet.");
      }
    }

    catch (e) {
      showErrorDialog("Terjadi kesalahan sistem.");
    }

    finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(String code, String reason) async {
    try {
      isLoading.value = true;

      final result = await _bookingService.cancelBooking(code, reason);

      if (result == true) {
        if (Get.isDialogOpen ?? false) Get.back(closeOverlays: true);

        Get.offAllNamed('/home');

        Future.delayed(const Duration(milliseconds: 300), () {
          showTopSheet("Registrasi berhasil dibatalkan");
        });
      } else {
        showTopSheet("Gagal membatalkan registrasi");
      }
    } catch (e) {
      showTopSheet("Terjadi kesalahan sistem");
    } finally {
      isLoading.value = false;
    }
  }

  void showSuccessDialog(String message) {
    if (Get.context == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text("Berhasil"),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (Get.isDialogOpen ?? false) Get.back();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
  void showErrorDialog(String message) {
    if (Get.context == null) return;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          "Terjadi Kesalahan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (Get.isDialogOpen ?? false) Get.back();
            },
            child: const Text("OK"),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
  void selectDoctor(Doctor doctor) {
    selectedDoctor.value = doctor;
  }


  void setFromSchedule({
    required Doctor doctor,
    required String date,
  }) {
    selectedDoctor.value = doctor;
    selectedDoctorId.value = doctor.code;
    this.date.value = date;
    poly.value = doctor.polyCode;
  }

}
