import 'package:ausy/core/models/category.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
// import 'package:ausy/core/widgets/icon_box.dart';
import 'package:ausy/features/blog/controllers/blog_controller.dart';
import 'package:ausy/features/blog/views/widgets/blog_appbar.dart';
import 'package:ausy/features/blog/views/widgets/blog_category.dart';
import 'package:ausy/features/blog/views/widgets/blog_list.dart';
import 'package:ausy/features/category/controllers/category_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  BlogPageState createState() => BlogPageState();
}

class BlogPageState extends State<BlogPage> {
  final BlogController blogController =
      Get.put(BlogController(), permanent: true);
  final CategoryController categoryController =
      Get.put(CategoryController(), permanent: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blogController.blogs.clear();
      blogController.setCategory(0);
      blogController.loadBlogs(paging: true, page: 1);
      categoryController.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: blogController.scrollController,
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            snap: true,
            floating: true,
            elevation: 0,
            title: BlogAppBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Row(
            children: [
              Expanded(
                child: CustomTextBox(
                  hint: "Cari",
                  prefix: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  onSubmitted: (value) {
                    blogController.changeQuery(value);
                  },
                ),
              ),
              // const SizedBox(
              //   width: 10,
              // ),
              // IconBox(
              //   bgColor: AppColor.primary,
              //   radius: 10,
              //   onTap: () {},
              //   child: SvgPicture.asset(
              //     "assets/icons/filter.svg",
              //     colorFilter:
              //         const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              //     width: 24,
              //     height: 24,
              //   ),
              // )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (categoryController.categories.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                ),
              ),
            );
          }
          categoryController.categories.insert(
            0,
            Category(
              id: 0,
              name: 'Semua',
            ),
          );
          return BlogCategory(categories: categoryController.categories);
        }),
        Obx(() {
          if (blogController.blogs.isEmpty) {
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            );
          }
          return BlogList(
              isLoading: blogController.isLoading.value,
              blogs: blogController.blogs);
        }),
        // SizedBox(height: 10),
        // ExploreCategory(),
        // SizedBox(height: 10),
        // ExploreCourseList(),
      ],
    );
  }
}
