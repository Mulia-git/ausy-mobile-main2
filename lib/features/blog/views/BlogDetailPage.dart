import 'package:ausy/core/models/blog.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({
    super.key,
    required this.blog,
  });

  final Blog blog;

  /// SHARE
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

  /// OPEN IMAGE FULLSCREEN
  void _openImageViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [

            /// ZOOM IMAGE + CACHE
            InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: blog.image,
                  fit: BoxFit.contain,

                  /// SHIMMER LOADING
                  placeholder: (context, url) => Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade700,
                      child: Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),

            /// CLOSE BUTTON
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SHIMMER IMAGE HEADER
  Widget _shimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: _shareArticle,
        child: const Icon(Icons.share, color: Colors.white),
      ),

      body: CustomScrollView(
        slivers: [

          /// HEADER IMAGE
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColor.primary,
            iconTheme: const IconThemeData(color: Colors.white),

            actions: [
              IconButton(
                icon: const Icon(Icons.share,
                    color: Colors.white),
                onPressed: _shareArticle,
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  /// CLICKABLE IMAGE
                  if (blog.image.isNotEmpty)
                    Positioned.fill(
                      child: InkWell(
                        onTap: () => _openImageViewer(context),
                        child: CachedNetworkImage(
                          imageUrl: blog.image,
                          fit: BoxFit.cover,

                          /// SHIMMER
                          placeholder: (context, url) =>
                              _shimmerImage(),

                          errorWidget:
                              (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    ),

                  /// GRADIENT
                  IgnorePointer(
                    child: Container(
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
                  ),

                  /// TITLE
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

          /// CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(20, 20, 20, 30),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// DATE
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(
                      color: AppColor.primary
                          .withOpacity(0.1),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule,
                            size: 14,
                            color: AppColor.primary),
                        const SizedBox(width: 6),
                        Text(
                          blog.date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w500,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DIVIDER
                  Container(
                    height: 1,
                    width: 60,
                    color: AppColor.primary,
                  ),

                  const SizedBox(height: 20),

                  /// CONTENT
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: blog.content
                        .split('\n\n')
                        .map(
                          (paragraph) => Padding(
                        padding:
                        const EdgeInsets.only(
                            bottom: 16),

                        child: Text(
                          paragraph.trim(),
                          textAlign:
                          TextAlign.justify,

                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color:
                            AppColor.textColor,
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