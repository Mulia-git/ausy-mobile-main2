import 'package:ausy/core/models/blog.dart';
import 'package:ausy/features/blog/views/widgets/blog_item.dart';
import 'package:ausy/features/blog/views/widgets/shimmer_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogList extends StatelessWidget {
  const BlogList({super.key, required this.blogs, required this.isLoading});
  final List<Blog> blogs;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.55,
              ),
              itemCount: blogs.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  right: 15, bottom: 5, top: 10, left: 15),
              itemBuilder: (context, index) {
                return BlogItem(
                  data: blogs[index],
                );
              },
            ),
            if (isLoading)
              GridView.count(
                padding: const EdgeInsets.only(
                    right: 15, bottom: 5, top: 10, left: 15),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.85,
                children: const [
                  ShimmerItem(),
                  ShimmerItem(),
                  ShimmerItem(),
                  ShimmerItem(),
                  ShimmerItem(),
                  ShimmerItem(),
                  ShimmerItem(),
                ],
              ),
          ],
        ));
  }
}
