import 'package:ausy/core/models/category.dart';
import 'package:ausy/core/services/category_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  final CategoryService _categoryService = CategoryService();

  Future<void> loadCategories() async {
    categories.value = [];
    categories.value = await _categoryService.fetchCategories();
  }
}
