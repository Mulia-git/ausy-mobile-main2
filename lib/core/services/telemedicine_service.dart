import 'dart:convert';

import 'package:ausy/core/models/telemedicine.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class TelemedicineService {
  final DioService _dioService = DioService();

  Future<List<Telemedicine>> fetchTelemedicines(String date) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'telemedicine',
          'tanggal': date,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Telemedicine> telemedicines = Telemedicine.fromJsonList(data);
        return telemedicines;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
