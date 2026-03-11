import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import 'dio_service.dart';

class PanicService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<Map<String, dynamic>?> sendPanic({
    required double lat,
    required double lng,
    required String alamat,
  }) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        data: {
          'action': 'panic',
          'token': ApiConstants.token,
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
          'lat': lat,
          'lng': lng,
          'alamat': alamat,
        },
      );

      print("Response panic: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null && data is List && data.isNotEmpty) {
          return data[0];
        }
      }
    } catch (e) {
      print("Error panic: $e");
    }
    return null;
  }

  /// ❌ Cancel Panic
  Future<bool> cancelPanic() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'panic_cancel',
          'token': ApiConstants.token,
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        return data[0]['state'] == 'cancelled';
      }
    } catch (e) {
      print('Error cancel panic: $e');
    }

    return false;
  }

  /// 📜 Riwayat Panic
  Future<List<dynamic>> getHistory() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'panic_history',
          'token': ApiConstants.token,
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      }
    } catch (e) {
      print('Error history panic: $e');
    }

    return [];
  }

  /// 🔎 Cek Panic Aktif
  Future<Map<String, dynamic>?> checkActivePanic() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'panic_check',
          'token': ApiConstants.token,
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);

        if (data.isNotEmpty) {
          return data[0];
        }
      }
    } catch (e) {
      print('Error check panic: $e');
    }

    return null;
  }
}