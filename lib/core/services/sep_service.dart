import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/sep_bpjs.dart';

import 'dio_service.dart';
import '../constants/api_constants.dart';

class SepService {
  final DioService _dioService = DioService();
  Future<SepBpjs?> fetchSep(String noRawat) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "sep_bpjs",
          "no_rawat": noRawat
        },
      );

      if (res.data['status'] == true) {
        return SepBpjs.fromJson(res.data);
      }
    } catch (e) {

    }
    return null;
  }



}
