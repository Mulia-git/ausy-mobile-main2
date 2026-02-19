import 'dart:convert';

import '../constants/api_constants.dart';
import '../models/operasi_model.dart';
import 'dio_service.dart';

class OperasiService {
  final DioService _dioService = DioService();

  Future<OperasiModel?> fetchOperasi(String noRawat) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "operasi",
          "no_rawat": noRawat,
        },
      );

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      if (data == null) return null;

      return OperasiModel.fromJson(data);

    } catch (_) {
      return null;
    }
  }
}
