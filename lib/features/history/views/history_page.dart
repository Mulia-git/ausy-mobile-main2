import 'package:ausy/core/models/category.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
// import 'package:ausy/core/widgets/icon_box.dart';
import 'package:ausy/features/history/controllers/history_controller.dart';
import 'package:ausy/features/history/views/widgets/category_item.dart';
import 'package:ausy/features/history/views/widgets/history_appbar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final HistoryController historyController =
      Get.put(HistoryController(), permanent: true);
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxBool showFab = false.obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      historyController.billings.clear();
      historyController.changeCategory('Booking');
      historyController.loadBooking();
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            snap: true,
            floating: true,
            elevation: 0,
            title: HistoryAppBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(context),
              childCount: 1,
            ),
          )
        ],
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
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      // if (historyController.selectedCategory.value == 'Billing') {
      //   return _buildBilling();
      // }
      if (historyController.selectedCategory.value == 'Booking') {
        return _buildBooking();
      }
      if (historyController.selectedCategory.value == 'Ralan') {
        return _buildOutpatient();
      }
      if (historyController.selectedCategory.value == 'Ranap') {
        return _buildInpatient();
      }
      return _buildEmptyState(context);
    });
  }

  Column _buildBilling() {
    final categories = [
      'Booking',
      'Ralan',
      'Ranap',
      // 'Billing',
    ];

    return Column(
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
                  hint: "Cari",
                  prefix: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    historyController.changeQuery(value);
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
                      historyController.selectedCategory.value,
                  onTap: () {
                    setState(() {
                      historyController.changeCategory(categories[index]);
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
          child: historyController.isLoading.value
              ? ListView.builder(
                padding: EdgeInsets.zero,
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
              : historyController.filteredBillings.isNotEmpty
                  ? ListView.builder(
                    padding: EdgeInsets.zero,
                      itemCount: historyController.filteredBillings.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final billing =
                            historyController.filteredBillings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        billing.date,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        billing.code,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        billing.polyclinic,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Rp ${billing.total}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade200,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : _buildEmptyState(context),
        ),
      ],
    );
  }

  Column _buildBooking() {
    final categories = [
      'Booking',
      'Ralan',
      // 'Ranap',
      // 'Billing',
    ];

    return Column(
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
                  hint: "Cari",
                  prefix: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    historyController.changeQuery(value);
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
                      historyController.selectedCategory.value,
                  onTap: () {
                    setState(() {
                      historyController.changeCategory(categories[index]);
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
          child: historyController.isLoading.value
              ? ListView.builder(
                padding: EdgeInsets.zero,
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
              : historyController.filteredBookings.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: historyController.filteredBookings.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final booking =
                            historyController.filteredBookings[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/bookdetail', arguments: {
                            'date':
                                booking.checkDate,
                            'code': booking.code, // atau false, sesuai kebutuhan
                          });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              booking.checkDate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '/ ${booking.status}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: booking.status
                                                            .toLowerCase() ==
                                                        'sudah'
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          booking.polyclinic,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          booking.doctor,
                                          style:
                                              const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          booking.insurance,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.shade200,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : _buildEmptyState(context),
        ),
      ],
    );
  }

  Column _buildInpatient() {
    final categories = [
      'Booking',
      'Ralan',
      // 'Ranap',
      // 'Billing',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Search Box
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
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
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    historyController.changeQuery(value);
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
                      historyController.selectedCategory.value,
                  onTap: () {
                    setState(() {
                      historyController.changeCategory(categories[index]);
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
          child: historyController.isLoading.value
              ? ListView.builder(
                padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
              itemBuilder: (context, index) {
                final outpatient = historyController.filteredOutpatients[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// BARIS 1 → NO RAWAT & TANGGAL
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              outpatient.code, // no_rawat
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              outpatient.date, // tgl_registrasi
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// BARIS 2 → POLI
                        Text(
                          outpatient.polyclinic,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// BARIS 3 → DOKTER & CARA BAYAR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                outpatient.doctor,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                outpatient.payment, // png_jawab
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

          )
              : historyController.filteredOutpatients.isNotEmpty
                  ? ListView.builder(
                    padding: EdgeInsets.zero,
                      itemCount: historyController.filteredOutpatients.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final outpatient =
                            historyController.filteredOutpatients[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        outpatient.code,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        outpatient.polyclinic,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        outpatient.code,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade200,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : _buildEmptyState(context),
        ),
      ],
    );
  }

  Column _buildOutpatient() {
    final categories = [
      'Booking',
      'Ralan',
      // 'Ranap',
      // 'Billing',
    ];

    return Column(
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
                  hint: "Cari",
                  prefix: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    historyController.changeQuery(value);
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
                      historyController.selectedCategory.value,
                  onTap: () {
                    setState(() {
                      historyController.changeCategory(categories[index]);
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
          child: historyController.isLoading.value
              ? ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                ),
              );
            },
          )

              : historyController.filteredOutpatients.isNotEmpty
              ? ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: historyController.filteredOutpatients.length,
            itemBuilder: (context, index) {
              final outpatient = historyController.filteredOutpatients[index];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Get.toNamed('/ralan-detail', arguments: outpatient);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// NO RAWAT & TANGGAL
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              outpatient.code,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              outpatient.date,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// POLI
                        Text(
                          outpatient.polyclinic,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// DOKTER & CARA BAYAR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                outpatient.doctor,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                outpatient.payment,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },

          )

              : _buildEmptyState(context),

        ),
      ],
    );
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
