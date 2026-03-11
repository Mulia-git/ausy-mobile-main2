import 'dart:ui';
import 'package:ausy/core/models/blog.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({
    super.key,
    required this.blog,
  });

  final Blog blog;

  void _shareArticle() {
    final url = "https://rsaurasyifa.com/${blog.slug}";

    Share.share(
      "📰 ${blog.title}\n\n"
          "Baca artikel lengkap hanya di Website Resmi RS Aura Syifa:\n"
          "$url\n\n"
          "#RSAuraSyifa",
      subject: blog.title,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: _shareArticle,
        child: const Icon(Icons.share, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColor.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _shareArticle,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (blog.image.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageViewer(
                              imageUrl: blog.image,
                              tag: "blogImage${blog.id}",
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: "blogImage${blog.id}",
                        child: CustomImage(
                          blog.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Text(
                      blog.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// DATE CHIP
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule,
                            size: 14, color: AppColor.primary),
                        const SizedBox(width: 6),
                        Text(
                          blog.date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DIVIDER STYLE
                  Container(
                    height: 1,
                    width: 60,
                    color: AppColor.primary,
                  ),

                  const SizedBox(height: 20),

                  /// HTML CONTENT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: blog.content
                        .split('\n\n')
                        .map(
                          (paragraph) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          paragraph.trim(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          PhotoView(
            heroAttributes: PhotoViewHeroAttributes(tag: tag),
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),

          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}