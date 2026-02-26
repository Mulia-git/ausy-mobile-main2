import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/features/available/controllers/available_controller.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/available/views/available_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AvailablePage extends StatefulWidget {
  const AvailablePage({super.key});

  @override
  State<AvailablePage> createState() => _AvailablePageState();
}

class _AvailablePageState extends State<AvailablePage> {
  final AvailableController availableController =
  Get.put(AvailableController(), permanent: true);

  final ScrollController _scrollController = ScrollController();
  final RxBool showFab = false.obs;
  final PageController pageController =
  PageController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      availableController.changeQuery('');
      availableController.loadRooms();

      _scrollController.addListener(() {
        showFab.value = _scrollController.offset > 100;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Ketersediaan Kamar",
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Obx(() => showFab.value
          ? FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.arrow_upward),
      )
          : const SizedBox.shrink()),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: availableController.isLoading.value
                ? _buildShimmer()
                : availableController.filteredAvailables.isNotEmpty
                ? ListView.builder(
              itemCount:
              availableController.filteredAvailables.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final room =
                availableController.filteredAvailables[index];

                final double percentage =
                int.parse(room.total) == 0
                    ? 0
                    : int.parse(room.available) /
                    int.parse(room.total);



                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>AvailableDetailPage(
                          className: room.className,
                          description: room.description,
                          total: room.total,
                          booked: room.booked,
                          available: room.available,
                          images: room.images,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        if (room.images.isNotEmpty)
                          AutoImageSlider(images: room.images),

                        Text(
                          room.className,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(

                          _stripHtml(room.description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),


                        Text(
                          "${room.available} / ${room.total} Tersedia",
                          style: TextStyle(
                            fontSize: 15,
                            color:
                            Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),


                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0,
                              end: percentage),
                          duration:
                          const Duration(
                              milliseconds: 800),
                          builder: (context, value,
                              child) {
                            return ClipRRect(
                              borderRadius:
                              BorderRadius.circular(
                                  10),
                              child:
                              LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors
                                    .grey.shade300,
                                color: value == 0
                                    ? Colors.red
                                    : value < 0.5
                                    ? AppColor
                                    .primary
                                    : Colors.orange,
                                minHeight: 8,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : _buildEmptyState(context),
          ),
        ),
      );
    });
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.15,
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/no-data.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ooops , tidak ada data.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Maaf data yang anda cari tidak ditemukan.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
class AutoImageSlider extends StatefulWidget {
  final List<String> images;

  const AutoImageSlider({super.key, required this.images});

  @override
  State<AutoImageSlider> createState() => _AutoImageSliderState();
}

class _AutoImageSliderState extends State<AutoImageSlider> {
  late PageController _controller;
  int _currentPage = 0;
  late final PageController pageController;
  late final Duration autoSlideDuration;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    autoSlideDuration = const Duration(seconds: 3);

    Future.delayed(autoSlideDuration, autoSlide);
  }

  void autoSlide() async {
    if (!mounted) return;

    if (_controller.hasClients) {
      _currentPage++;

      if (_currentPage >= widget.images.length) {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    Future.delayed(autoSlideDuration, autoSlide);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (widget.images.length > 1)
          SmoothPageIndicator(
            controller: _controller,
            count: widget.images.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColor.primary,
              dotColor: Colors.grey.shade300,
            ),
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}
String _stripHtml(String htmlString) {
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
}