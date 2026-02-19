import 'package:ausy/core/models/category.dart';
import 'package:ausy/features/blog/controllers/blog_controller.dart';
import 'package:ausy/features/blog/views/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogCategory extends StatefulWidget {
  const BlogCategory({super.key, required this.categories});
  final List<Category> categories;
  @override
  State<BlogCategory> createState() => _ExploreCategoryState();
}

class _ExploreCategoryState extends State<BlogCategory> {
  int selectedCategory = 0;
  final BlogController blogController = Get.put(BlogController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
      child: Row(
        children: List.generate(
          widget.categories.length,
          (index) => CategoryItem(
            data: widget.categories[index],
            isSelected: selectedCategory == index,
            onTap: () {
              setState(() {
                selectedCategory = index;
                blogController.changeCategory(widget.categories[index].id);
              });
            },
          ),
        ),
      ),
    );
  }
}
