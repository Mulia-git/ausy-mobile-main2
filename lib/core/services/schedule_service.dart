import 'dart:convert';

import 'package:ausy/core/models/schedule.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class ScheduleService {
  final DioService _dioService = DioService();

  Future<List<Schedule>> fetchSchedules(String date) async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'jadwalklinik',
          'tanggal':date
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Schedule> schedules = Schedule.fromJsonList(data);
        return schedules;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
