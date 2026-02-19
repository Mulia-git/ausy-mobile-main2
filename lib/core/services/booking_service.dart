import 'dart:convert';

import 'package:ausy/core/models/booking.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dio_service.dart';

class BookingService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<List<Booking>> fetchBooking() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'booking',
          'no_rkm_medis' : storage.read('medicalRecord') ?? ''
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Booking> bookings = Booking.fromJsonList(data);
        return bookings;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
  Future<Booking?> fetchBookingDetail(String date,String code) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'bookingdetail',
          'no_rkm_medis' : storage.read('medicalRecord') ?? '',
          'no_reg':code,
          'tanggal_periksa':date
        },
      );
      if (response.statusCode == 200) {
         final List<dynamic> data = jsonDecode(response.data);
        Booking booking = Booking.fromJson(data[0]);
        return booking;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return null;
  }
  Future<Booking?> fetchActiveBooking(String medicalRecord) async {
    try {
      final response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'cek_booking_aktif',
          'no_rkm_medis': medicalRecord,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        if (data != null && data.isNotEmpty) {
          return Booking.fromJson(data);
        }
      }
    } catch (e) {

    }
    return null;
  }
  Future<Booking?> fetchBookingSuccess(String date,String code) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'sukses',
          'no_rkm_medis' : storage.read('medicalRecord') ?? '',
        },
      );
      if (response.statusCode == 200) {
         final List<dynamic> data = jsonDecode(response.data);
        Booking booking = Booking.fromJson(data[0]);
        return booking;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return null;
  }
  Future<bool> cancelBooking(String code, String reason) async {
    try {
      final response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'batal',
          'no_reg': code,
          'alasan': reason,
          'no_rkm_medis': storage.read('medicalRecord'),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        return data['status'] == 'success';
      }
    } catch (e) {}

    return false;
  }


}
