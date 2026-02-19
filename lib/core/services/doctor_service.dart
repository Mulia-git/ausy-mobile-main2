import 'dart:convert';

import 'package:ausy/core/models/doctor.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class DoctorService {
  final DioService _dioService = DioService();

  Future<List<Doctor>> fetchDoctors(String date) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'dokter',
          'tanggal': date,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Doctor> doctors = Doctor.fromJsonList(data);
        return doctors;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }

  Future<List<Doctor>> fetchScheduleDoctors(String date, String poly) async {
    try {


      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'jadwaldokter',
          'tanggal': date,
          'kd_poli': poly
        },
      );



      final List<dynamic> data = jsonDecode(response.data);
      return Doctor.fromJsonList(data);
    } catch (e) {

    }
    return [];
  }

}
