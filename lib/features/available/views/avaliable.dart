import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/features/available/controllers/available_controller.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

class AvailablePage extends StatefulWidget {
  const AvailablePage({super.key});

  @override
  State<AvailablePage> createState() => _AvailablePageState();
}

class _AvailablePageState extends State<AvailablePage> {
  final AvailableController availableController =
      Get.put(AvailableController(), permanent: true);
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxBool showFab = false.obs;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      availableController.changeQuery('');
      availableController.loadRooms();
      _scrollController.addListener(() {
        if (_scrollController.offset > 100) {
          if (!showFab.value) showFab.value = true;
        } else {
          if (showFab.value) showFab.value = false;
        }
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
      floatingActionButton: Obx(() {
        return showFab.value
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
            : const SizedBox.shrink();
      }),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // List of Doctors
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: availableController.isLoading.value
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                    : availableController.filteredAvailables.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                availableController.filteredAvailables.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final room =
                                  availableController.filteredAvailables[index];
                              final double percentage =
                                  int.parse(room.total) == 0
                                      ? 0
                                      : int.parse(room.available) /
                                          int.parse(room.total);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      room.className,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${room.available} / ${room.total} Tersedia",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0,
                                        end:
                                            percentage, // dari perhitungan room.available / room.total
                                      ),
                                      duration:
                                          const Duration(milliseconds: 800),
                                      builder: (context, value, child) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            value: value,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            color: value == 0
                                                ? Colors.red
                                                : value < 0.5
                                                    ? AppColor.primary
                                                    : Colors.orange,
                                            minHeight: 8,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : _buildEmptyState(context),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.15,
        right: 20.5,
        left: 20.5,
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/no-data.json', // Ganti path sesuai file kamu
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ooops , tidak ada data.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
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
