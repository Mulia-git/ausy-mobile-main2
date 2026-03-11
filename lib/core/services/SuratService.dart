import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import 'dio_service.dart';

class SuratService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  /// Generate PDF Surat Keterangan
  Future<String?> generateSurat(String noRawat) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'surat_keterangan_sehat_pdf',
          'token': ApiConstants.token,
          'no_rawat': noRawat,
          'no_rkm_medis': storage.read('medicalRecord') ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);

        if (data != null && data['state'] == 'success') {
          return data['url'];
        }
      }
    } catch (e) {
      print('Error generate surat: $e');
    }

    return null;
  }

}