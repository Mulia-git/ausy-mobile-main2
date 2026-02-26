import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/features/blog/controllers/blog_controller.dart';
import 'package:ausy/features/blog/views/widgets/blog_appbar.dart';
import 'package:ausy/features/blog/views/widgets/blog_item.dart';
import 'package:ausy/features/blog/views/widgets/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';

class BlogPage extends StatelessWidget {
  BlogPage({super.key});

  final BlogController blogController =
  Get.put(BlogController(), permanent: true);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: blogController.refreshBlogs,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [

            const SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              elevation: 0,
              title: Text(
                "Artikel",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: Obx(() {
                if (blogController.isLoading.value &&
                    blogController.blogs.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (blogController.blogs.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("Belum ada artikel"),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: BlogItem(
                          data: blogController.blogs[index],
                        ),
                      );
                    },
                    childCount: blogController.blogs.length,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
