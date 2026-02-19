import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class FcmService {
  final Dio _dio = DioService().dio;

  Future<bool> saveDeviceToken({
    required String noRkmMedis,
  }) async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return false;

      final response = await _dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'save_device_token',
          'no_rkm_medis': noRkmMedis,
          'device_token': token,
          'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
        },
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['status'] == 'success') {
        return true;
      }
    } catch (e) {
      // ignore
    }

    return false;
  }
}
