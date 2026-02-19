import 'package:ausy/core/models/blog.dart';
import 'package:ausy/core/services/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogController extends GetxController {
  RxList<Blog> blogs = <Blog>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;
  RxInt selectedCategory = 0.obs; // Kategori yang dipilih
  RxString searchQuery = ''.obs;

  final ScrollController scrollController = ScrollController();
  final BlogService _blogService = BlogService();
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  Future<void> loadBlogs({bool paging = false, int page = 1}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    List<Blog> newBlogs = await _blogService.fetchBlogs(selectedCategory.value,
        paging: paging, page: page, query: searchQuery.value);
    if (newBlogs.isNotEmpty) {
      if (newBlogs.length <= 10) {
        hasMore.value = false;
      }
      blogs.addAll(newBlogs);
    } else {
      hasMore.value = false; // Tidak ada lagi data
    }
    isLoading.value = false;
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      loadMoreBlogs();
    }
  }

  void loadMoreBlogs() {
    if (hasMore.value && !isLoading.value) {
      currentPage.value++;
      loadBlogs(paging: true, page: currentPage.value);
    }
  }

  void changeCategory(int categoryId) {
    selectedCategory.value = categoryId;
    blogs.clear(); // Hapus daftar blog sebelum memuat ulang
    currentPage.value = 1; // Reset halaman ke 1
    hasMore.value = true;
    loadBlogs(paging: true, page: currentPage.value);

    // Kembalikan scroll ke atas
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setCategory(int categoryId) {
    selectedCategory.value = categoryId;
  }

  void changeQuery(String query) {
    searchQuery.value = query;
    blogs.clear(); // Hapus daftar blog sebelum memuat ulang
    currentPage.value = 1; // Reset halaman ke 1
    hasMore.value = true;
    loadBlogs(paging: true, page: currentPage.value);

    // Kembalikan scroll ke atas
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
