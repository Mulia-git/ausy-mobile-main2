import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as storage;

import 'dio_service.dart';

class QrService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();
  Future<Map<String, dynamic>> verifyQR({
    required String tokenVerif,
    required String expiredAt,
    required String signature,
    required String noReg,
    required String noRm,
  }) async {
    try {


      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'scan-qr',
          "tokenVerif": tokenVerif,
          "expired_at": expiredAt,
          "signature": signature,
          "no_reg": noReg,
          "no_rkm_medis": noRm ?? '',
        },

      );
      print("RESPONSE QR:");
      print(response.data);

      if (response.data == null || response.data.toString().isEmpty) {
        return {
          "status": "success",
          "message": "Berhasil (tanpa response)"
        };
      }

      return response.data is String
          ? jsonDecode(response.data)
          : response.data;

    } catch (e) {
      return {
        "status": "error",
        "message": e.toString()
      };
    }
  }
}