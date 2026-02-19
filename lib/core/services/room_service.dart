import 'dart:convert';

import 'package:ausy/core/models/room.dart';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'dio_service.dart';

class RoomService {
  final DioService _dioService = DioService();

  Future<List<Room>> fetchRooms() async {
    try {
      Response response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          'action': 'rawatinap',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.data);
        List<Room> rooms = Room.fromJsonList(data);
        return rooms;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching doctor: $e');
    }
    return [];
  }
}
