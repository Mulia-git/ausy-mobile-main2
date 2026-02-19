import 'dart:convert';

import 'package:ausy/core/models/inpatient.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dio_service.dart';

class InpatientService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<List<Inpatient>> fetchInPatients() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'riwayat',
          'no_rkm_medis' : storage.read('medicalRecord') ?? ''
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Inpatient> inpatients = Inpatient.fromJsonList(data);
        return inpatients;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
