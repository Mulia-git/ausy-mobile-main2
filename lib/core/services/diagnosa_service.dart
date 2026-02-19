import 'dio_service.dart';
import '../constants/api_constants.dart';


  class DiagnosaService {
  final DioService _dioService = DioService();

  Future<Map<String, dynamic>> fetchData(String noRawat) async {
  final res = await _dioService.dio.get(
  ApiConstants.baseUrl,
  queryParameters: {
  "action": "diagnosa_prosedur",
  "no_rawat": noRawat
  },
  );

  return res.data;

  }
  }

