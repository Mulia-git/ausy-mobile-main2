import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/soap_model.dart';
import 'dio_service.dart';
import '../constants/api_constants.dart';

class SoapService {
  final DioService _dioService = DioService();
  Future<List<Soap>> fetchSoap(String noRawat) async {
    try {
      final response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'soap',
          'no_rawat': noRawat,
        },
      );

      // print("==== RAW SOAP RESPONSE ====");
      // print(response.data);

      final Map<String, dynamic> json = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      final List soapArray = (json['soap'] as List?) ?? [];

      return Soap.fromJsonList(soapArray);


    } catch (e) {
      // print("Error SOAP SERVICE: $e");
      return [];
    }
  }


}
