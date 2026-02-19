import 'dart:convert';

import 'package:ausy/core/models/payment.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class PaymentService {
  final DioService _dioService = DioService();

  Future<List<Payment>> fetchPayments() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'carabayar',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Payment> payments = Payment.fromJsonList(data);
        return payments;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
