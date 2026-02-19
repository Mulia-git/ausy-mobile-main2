import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/customer.dart';
import 'package:get_storage/get_storage.dart';
import 'dio_service.dart';

class AuthService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<Customer?> fetchCustomerData() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'profil',
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        return Customer.fromJson(data);
      }
    } catch (e) {
      print('Error fetching customer data: $e');
    }
    return null;
  }


  Customer? getCustomerFromStorage() {
    final data = storage.read('customer');
    if (data != null) {
      return Customer.fromJson(data);
    }
    return null;
  }

  void clearCustomerData() {
    storage.remove('customer');
  }

  void clearUserData() {
    storage.remove('user');
  }
}
