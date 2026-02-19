import 'dart:convert';

import '../constants/api_constants.dart';
import '../models/radiologi_model.dart';
import 'dio_service.dart';

class RadiologiService {
  final DioService _dioService = DioService();

  Future<RadiologiModel?> fetchRadiologi(String noRawat) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "radiologi",
          "no_rawat": noRawat,
        },
      );

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      if (data == null) return null;

      return RadiologiModel.fromJson(data);

    } catch (_) {
      return null;
    }
  }
}
