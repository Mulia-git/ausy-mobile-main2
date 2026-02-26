import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ausy/core/themes/app_colors.dart';

class AvailableDetailPage extends StatefulWidget {
  final String className;
  final String description;
  final String total;
  final String booked;
  final String available;
  final List<String> images;

  const AvailableDetailPage({
    super.key,
    required this.className,
    required this.description,
    required this.total,
    required this.booked,
    required this.available,
    required this.images,
  });

  @override
  State<AvailableDetailPage> createState() =>
      _AvailableDetailPageState();
}

class _AvailableDetailPageState
    extends State<AvailableDetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final Duration _autoSlideDuration;
  @override
  void initState() {
    super.initState();
    _autoSlideDuration = const Duration(seconds: 3);

    Future.delayed(_autoSlideDuration, _autoSlide);
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _openImageViewer(int initialIndex) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              controller:
              PageController(initialPage: initialIndex),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close,
                    color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double percentage =
    int.parse(widget.total) == 0
        ? 0
        : int.parse(widget.available) /
        int.parse(widget.total);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.className),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [


            if (widget.images.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount:
                      widget.images.length,
                      itemBuilder:
                          (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              _openImageViewer(
                                  index),
                          child: Image.network(
                            widget.images[index],
                            fit: BoxFit.cover,
                            width:
                            double.infinity,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.images.length > 1)
                    SmoothPageIndicator(
                      controller:
                      _pageController,
                      count:
                      widget.images.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor:
                        AppColor.primary,
                        dotColor:
                        Colors.grey.shade300,
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 20),

            Padding(
              padding:
              const EdgeInsets.symmetric(
                  horizontal: 16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [


                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      _buildStatBox(
                          "Kapasitas",
                          widget.total),
                      _buildStatBox(
                          "Terisi",
                          widget.booked),
                      _buildStatBox(
                          "Sisa",
                          widget.available),
                    ],
                  ),

                  const SizedBox(height: 20),


                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child:
                    LinearProgressIndicator(
                      value: percentage,
                      backgroundColor:
                      Colors.grey.shade300,
                      color: percentage == 0
                          ? Colors.red
                          : percentage < 0.5
                          ? AppColor.primary
                          : Colors.orange,
                      minHeight: 8,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    widget.className,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Deskripsi Kamar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Html(
                    data: widget.description,
                    style: {
                      "body": Style(
                        fontSize: FontSize(15),
                        lineHeight: LineHeight(1.6),
                      ),
                      "ul": Style(
                        margin: Margins.symmetric(vertical: 10),
                      ),
                      "li": Style(
                        margin: Margins.only(bottom: 8),
                      ),
                      "p": Style(
                        margin: Margins.only(bottom: 10),
                      ),
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
      String title, String value) {
    return Expanded(
      child: Container(
        margin:
        const EdgeInsets.symmetric(
            horizontal: 5),
        padding:
        const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                AppColor.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  void _autoSlide() {
    if (!mounted) return;

    if (_pageController.hasClients && widget.images.length > 1) {
      _currentPage++;

      if (_currentPage >= widget.images.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    Future.delayed(_autoSlideDuration, _autoSlide);
  }
}
String _stripHtml(String htmlString) {
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
}