import 'dio_service.dart';
import '../constants/api_constants.dart';

class TindakanService {
  final DioService _dioService = DioService();

  Future<Map<String, dynamic>> fetchTindakan(String noRawat) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "tindakan",
          'no_rawat': noRawat,
        },
      );

      if (res.data == null) return {};

      if (res.data is String) {
        return {};
      }

      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      print("SERVICE ERROR TINDAKAN: $e");
      return {};
    }
  }
}
