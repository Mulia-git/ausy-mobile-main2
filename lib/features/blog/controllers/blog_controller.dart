import 'package:ausy/core/models/blog.dart';
import 'package:ausy/core/services/blog_service.dart';
import 'package:get/get.dart';

class BlogController extends GetxController {

  final BlogService _blogService = BlogService();

  RxList<Blog> blogs = <Blog>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlogs();
  }

  /// 🔥 Load Semua Artikel
  Future<void> loadBlogs() async {
    try {
      isLoading.value = true;

      final result = await _blogService.fetchBlogs();

      blogs.assignAll(result);

    } catch (e) {
      print("BLOG LOAD ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Pull To Refresh
  Future<void> refreshBlogs() async {
    final result = await _blogService.fetchBlogs();

    blogs.assignAll(result);
  }

  /// 🔥 Load Artikel Terbaru (Homepage)
  Future<void> loadLatestBlogs({int limit = 3}) async {
    try {
      isLoading.value = true;

      final result = await _blogService.fetchLatestBlogs(limit);

      blogs.assignAll(result);

    } catch (e) {
      print("LATEST BLOG ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}