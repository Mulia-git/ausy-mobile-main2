import 'dart:convert';

import 'package:ausy/core/models/available.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class AvailableService {
  final DioService _dioService = DioService();

  Future<List<Available>> fetchRooms() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'kamar',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Available> rooms = Available.fromJsonList(data);
        return rooms;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching available: $e');
    }
    return [];
  }
}
