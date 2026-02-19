import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/blog.dart';
import 'dio_service.dart';

class BlogService {
  final DioService _dioService = DioService();

  Future<List<Blog>> fetchBlogs(int categoryId,
      {bool paging = false, int page = 1, String query = ''}) async {
    try {
      Map<String, dynamic> queryParams = {
        '_embed': true,
        'order': 'desc', // Descending order (latest posts first)
        'orderby': 'date', // Order by creation date
        'per_page': 10,
      };

      if (categoryId != 0) {
        queryParams['categories'] = categoryId;
      }
      if (paging) {
        queryParams['page'] = page;
      }
      // Menambahkan parameter pencarian berdasarkan judul
      if (query.isNotEmpty) {
        queryParams['search'] =
            query; // Asumsi API mendukung query pencarian berdasarkan judul
      }
      Response response = await _dioService.dio.get(
        ApiConstants.listPostEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Blog> blogs = data.map((json) => Blog.fromJson(json)).toList();
        return blogs;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching posts: $e');
    }
    return [];
  }
}
