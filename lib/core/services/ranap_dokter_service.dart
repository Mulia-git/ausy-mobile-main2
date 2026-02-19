import '../constants/api_constants.dart';
import 'dio_service.dart';

class TindakanRanapDokterService {
  final DioService _dioService = DioService();

  Future<Map<String, dynamic>> fetch(String noRawat) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "tindakan_ranap_dokter",
          "no_rawat": noRawat,
        },
      );
      return Map<String, dynamic>.from(res.data ?? {});
    } catch (_) {
      return {};
    }
  }
}
