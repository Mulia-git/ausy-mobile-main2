import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/category.dart';
import 'dio_service.dart';

class CategoryService {
  final DioService _dioService = DioService();

  Future<List<Category>> fetchCategories() async {
    try {
      Response response =
          await _dioService.dio.get(ApiConstants.listCategoryEndpoint);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Category> categories =
            data.map((json) => Category.fromJson(json)).toList();
        return categories;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching posts: $e');
    }
    return [];
  }
}
