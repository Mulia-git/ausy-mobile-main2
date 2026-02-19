import 'dart:convert';

import 'package:ausy/core/models/complaint.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dio_service.dart';

class ComplaintService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<List<Complaint>> fetchComplaint() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'pengaduan',
          'no_rkm_medis' : storage.read('medicalRecord') ?? ''
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Complaint> complaints = Complaint.fromJsonList(data);
        return complaints;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
  Future<bool> sendComplaint(String noRkmMedis, String message) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'simpanpengaduan',
          'no_rkm_medis': noRkmMedis,
          'message': message,
        },
      );

      final data = jsonDecode(response.data);
      return data['state'] == 'success';
    } catch (e) {
      print("Error send complaint: $e");
      return false;
    }
  }

}
