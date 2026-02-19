import 'package:ausy/core/models/category.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/doctor/views/widgets/category_item.dart';
import 'package:ausy/features/polyclinic/controllers/polyclinic_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

class PolyclinicPage extends StatefulWidget {
  const PolyclinicPage({super.key});

  @override
  State<PolyclinicPage> createState() => _PolyclinicPageState();
}

class _PolyclinicPageState extends State<PolyclinicPage> {
  final PolyClinicController polyClinicController =
      Get.put(PolyClinicController(), permanent: true);
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxBool showFab = false.obs;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      polyClinicController.polyclinics.clear();
      polyClinicController.selectedCategory('Semua');
      polyClinicController.changeQuery('');
      polyClinicController.loadPolyclinics();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Poliklinik",
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
    final categories = [
      'Semua',
      'Umum',
      'Obgyn',
      'Mata',
      'Jantung',
      'Bedah',
      'Saraf',
    ];

    return Obx(() {
      return SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search Box
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextBox(
                        hint: "Cari poliklinik",
                        prefix: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 16,
                        ),
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          polyClinicController.changeQuery(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Shift Filter
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
                  child: Row(
                    children: List.generate(
                      categories.length,
                      (index) => CategoryItem(
                        data: Category(id: index, name: categories[index]),
                        isSelected: categories[index] ==
                            polyClinicController.selectedCategory.value,
                        onTap: () {
                          setState(() {
                            polyClinicController
                                .changeCategory(categories[index]);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // List of Doctors
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: polyClinicController.isLoading.value
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
                    : polyClinicController.filteredPolyclinics.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                polyClinicController.filteredPolyclinics.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final polyclinic = polyClinicController
                                  .filteredPolyclinics[index];
                              if (polyclinic.price != "0") {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              polyclinic.name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Rp  ${polyclinic.priceFormat}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
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
