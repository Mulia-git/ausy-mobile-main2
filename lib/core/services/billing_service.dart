import 'dart:convert';

import 'package:ausy/core/models/billing.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dio_service.dart';

class BillingService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<List<Billing>> fetchBlling() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'billing',
          'no_rkm_medis' : storage.read('medicalRecord') ?? ''
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Billing> billings = Billing.fromJsonList(data);
        return billings;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
