import 'dart:async';

import 'package:ausy/features/customer/views/widgets/category_list.dart';
import 'package:ausy/features/customer/views/widgets/doctor_item.dart';
import 'package:ausy/features/customer/views/widgets/notification_box.dart';
import 'package:ausy/features/doctor/controllers/doctor_controller.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/features/auth/controllers/auth_controller.dart';
import 'package:ausy/features/blog/controllers/blog_controller.dart';
// import 'package:ausy/features/customer/views/widgets/category_box.dart';
import 'package:ausy/features/customer/views/widgets/blog_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../blog/views/widgets/blog_item.dart';
import '../../book/controllers/book_controller.dart';
import '../../notification/controllers/notification_controller.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  CustomerPageState createState() => CustomerPageState();
}

class CustomerPageState extends State<CustomerPage> {
  final BookController bookController =
  Get.put(BookController(), permanent: true);
  final NotificationController notificationController =
  Get.put(NotificationController(), permanent: true);

  final AuthController authController =
      Get.put(AuthController(), permanent: true);
  final BlogController blogController =
      Get.put(BlogController(), permanent: true);
  final DoctorController doctorController =
      Get.put(DoctorController(), permanent: true);
  int _currentArticle = 0;
  int _currentBooking = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bookController.checkActiveBooking();

      blogController.blogs.clear();
      blogController.loadLatestBlogs(limit: 3);

      doctorController.doctors.clear();
      doctorController.changeQuery('');
      doctorController.changeShift("Semua");
      doctorController.setSelectedDate(
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

      authController.loadCustomerData();

      final customer = authController.customer.value;
      if (customer != null) {
        notificationController.fetchNotifications(

        );
      }
    });
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {

      if (!_scrollController.hasClients) return;

      double maxScroll = _scrollController.position.maxScrollExtent;
      double current = _scrollController.offset;

      double next = current + 260;

      if (next >= maxScroll) {
        next = 0;
      }

      _scrollController.animateTo(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

    // final List<Map<String, String>> categories = [
    //   {"name": "Semua", "icon": "assets/icons/category/all.svg"},
    //   {"name": "Basic", "icon": "assets/icons/category/basic.svg"},
    //   {"name": "Advance", "icon": "assets/icons/category/advance.svg"},
    // ];
    @override
    Widget build(BuildContext context) {
      // Tambahkan listener untuk mengecek data personal
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF63B790),
              pinned: true,
              snap: true,
              floating: true,
              elevation: 0,
              title: const Text(
                "Beranda",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                Obx(() {
                  return NotificationBox(
                    notifiedNumber:
                    notificationController.notificationCount, // UNREAD
                    onTap: () {
                      Get.toNamed('/notification');
                    },
                  );
                }),
                const SizedBox(width: 12),
              ],


            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: 200,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF63B790), // Hijau Muda
                                    Color(0xFF70BD97), // Hijau Tua
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(children: [
                                const SizedBox(
                                  height: 48,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (authController.customer.value ==
                                          null) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius
                                                  .circular(40),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.black,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      }
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child:Image(
                                          image: authController.customer.value!.imageProvider,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),

                                      );
                                    }),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Obx(
                                                () =>
                                            authController.customer.value ==
                                                null
                                                ? const Text(
                                              'Loading...',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                                : AutoSizeText(
                                                "Hi , ${authController.customer
                                                    .value!.name}",
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "Selamat datang di RS Aura Syifa",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                      .withValues(alpha: 0.8))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 28),
                                    Obx(() {
                                      final bookings = bookController.activeBookings;
                                      final isLoading = bookController.isCheckingBooking.value;

                                      if (isLoading) {
                                        return const SizedBox(
                                          height: 120,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      }

                                      /// tidak ada booking
                                      if (bookings.isEmpty) {
                                        return _buildRegisterCard(context);
                                      }

                                      /// jika hanya 1 booking
                                      if (bookings.length == 1) {
                                        final booking = bookings.first;
                                        return _buildBookingCard(context, booking);
                                      }

                                      /// jika lebih dari 1 booking
                                      return Column(
                                        children: [

                                          CarouselSlider.builder(
                                            itemCount: bookings.length,
                                            itemBuilder: (context, index, realIndex) {

                                              final booking = bookings[index];

                                              return _buildBookingCard(context, booking);

                                            },
                                            options: CarouselOptions(
                                              aspectRatio: 16 / 9,
                                              viewportFraction: 1,
                                              autoPlay: bookings.length > 1,
                                              height: 200,

                                              autoPlayInterval: const Duration(seconds: 4),
                                              enlargeCenterPage: false,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentBooking = index;
                                                });
                                              },
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          AnimatedSmoothIndicator(
                                            activeIndex: _currentBooking,
                                            count: bookings.length,
                                            effect: ExpandingDotsEffect(
                                              dotHeight: 7,
                                              dotWidth: 7,
                                              activeDotColor: AppColor.primary,
                                              dotColor: Colors.grey.shade300,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                    const SizedBox(height: 10),
                                  ],
                                )
                              ]),
                            ),
                          ]),
                          const CategoryList(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Jadwal Dokter Hari Ini",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    final controller = Get.find<
                                        DoctorController>();

                                    controller.changeQuery('');
                                    controller.changeShift('Semua');

                                    controller.setSelectedDate(
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.now()),
                                    );

                                    Get.toNamed('/doctor');
                                  },
                                  child: Row(
                                    children: const [
                                      Text(
                                        "Jadwal Selengkapnya",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 12, color: AppColor.primary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),
                          Obx(() {
                            return doctorController.doctors.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: SizedBox(
                                  height: 130,
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                            )
                                :SingleChildScrollView(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  doctorController.doctors.length,
                                      (index) =>
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),

                                        child: DoctorItem(
                                          data: doctorController.doctors[index],
                                        ),
                                      ),
                                ),
                              ),

                            );
                          }),
                          // const DoctorScheduleList(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Artikel Terbaru",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/blog');
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Lihat Artikel Lainnya",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: AppColor.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Obx(() {

                            if (blogController.isLoading.value) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: SizedBox(
                                    height: 120,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }


                            if (blogController.blogs.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 30),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 45,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Belum ada artikel tersedia",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }


                            return Column(
                              children: [

                                CarouselSlider.builder(
                                  itemCount: blogController.blogs.length > 5
                                      ? 5
                                      : blogController.blogs.length,
                                  itemBuilder: (context, index, realIndex) {

                                    final blog = blogController.blogs[index];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: BlogItem(data: blog),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 180,
                                    viewportFraction: 0.85,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(seconds: 4),
                                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                    enableInfiniteScroll: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentArticle = index;
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 10),

                                AnimatedSmoothIndicator(
                                  activeIndex: _currentArticle,
                                  count: blogController.blogs.length > 5
                                      ? 5
                                      : blogController.blogs.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 7,
                                    dotWidth: 7,
                                    activeDotColor: AppColor.primary,
                                    dotColor: Colors.grey.shade300,
                                  ),
                                ),

                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                childCount: 1,
              ),
            )
          ],
        ),
      );
    }
  Widget _buildBookingCard(BuildContext context, booking) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFf3f9f6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Status Pendaftaran",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Anda terdaftar pada tanggal ${booking.checkDate} "
                "di poli ${booking.polyclinic} ke dokter ${booking.doctor}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          /// BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              /// DAFTAR
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/app');
                },
                icon: const Icon(
                  Icons.app_registration_rounded,
                  size: 16,
                ),
                label: const Text("Daftar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63B790),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// DETAIL
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/bookdetail', arguments: {
                    'date': booking.checkDate,
                    'code': booking.code,
                  });
                },
                icon: const Icon(
                  Icons.receipt_long,
                  size: 16,
                ),
                label: const Text("Detail"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
    void _showWarningDialog(String message) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            "Peringatan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Get.back(),
              child: const Text("Mengerti"),
            ),
          ],
        ),
      );
    }
  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
  Widget _buildRegisterCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).size.height < 700 ? 64 : 56,
          ),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFf3f9f6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daftar Mandiri",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Silahkan lakukan pendaftaran mandiri klinik rawat jalan.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 0,
          right: 15,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed('/app');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF63B790),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.app_registration_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
