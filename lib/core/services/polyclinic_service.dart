import 'dart:convert';

import 'package:ausy/core/models/polyclinic.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class PolyclinicService {
  final DioService _dioService = DioService();

  Future<List<Polyclinic>> fetchPolyclinics() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'rawatjalan',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Polyclinic> polyclinics = Polyclinic.fromJsonList(data);
        return polyclinics;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
