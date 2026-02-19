import 'dart:convert';

import 'package:ausy/core/models/outpatient.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dio_service.dart';

class OutpatientService {
  final DioService _dioService = DioService();
  final GetStorage storage = GetStorage();

  Future<List<Outpatient>> fetchOutPatients() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'ralan_history',
          'no_rkm_medis': storage.read('medicalRecord') ?? ''
        },
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        return Outpatient.fromJsonList(data);
      }
    } on DioException catch (e) {

    } catch (e, s) {

    }
    return [];
  }


}
