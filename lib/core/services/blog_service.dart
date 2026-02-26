import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/blog.dart';
import 'dio_service.dart';

class BlogService {
  final DioService _dioService = DioService();

  /// 🔥 Ambil semua artikel
  Future<List<Blog>> fetchBlogs() async {
    try {
      final response = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "news", // sesuaikan dengan API kamu
        },
      );

      if (response.statusCode == 200) {

        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data is List) {
          return data.map<Blog>((e) => Blog.fromApi(e)).toList();
        }
      }
    } catch (e) {
      print('Error fetchBlogs: $e');
    }

    return [];
  }

  /// 🔥 Ambil artikel terbaru (limit)
  Future<List<Blog>> fetchLatestBlogs(int limit) async {
    try {
      final response = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "news",
          "limit": limit,
        },
      );

      if (response.statusCode == 200) {

        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data is List) {
          return data.map<Blog>((e) => Blog.fromApi(e)).toList();
        }
      }
    } catch (e) {
      print("Error fetchLatestBlogs: $e");
    }

    return [];
  }
}