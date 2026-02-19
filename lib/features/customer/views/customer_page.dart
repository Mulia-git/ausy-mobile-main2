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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bookController.checkActiveBooking();
      blogController.blogs.clear();
      blogController.setCategory(71);
      blogController.setQuery('');
      blogController.loadBlogs(paging: false);
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
                                      final booking = bookController
                                          .activeBooking.value;
                                      final hasBooking = booking != null;
                                      final isLoading = bookController
                                          .isCheckingBooking.value;

                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.fromLTRB(
                                              16,
                                              16,
                                              16,
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height < 700 ? 64 : 56,
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFf3f9f6),
                                              borderRadius: BorderRadius
                                                  .circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  isLoading
                                                      ? "Status Pendaftaran"
                                                      : hasBooking
                                                      ? "Status Pendaftaran"
                                                      : "Daftar Mandiri",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  isLoading
                                                      ? "Sedang mengambil data..."
                                                      : hasBooking
                                                      ? "Anda sudah terdaftar pada tanggal ${booking
                                                      .checkDate} "
                                                      "di poli ${booking
                                                      .polyclinic} ke dokter ${booking
                                                      .doctor}"
                                                      : "Silahkan lakukan pendaftaran mandiri klinik rawat jalan.",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          if (!isLoading)
                                            Positioned(
                                              bottom: 0,
                                              right: 15,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (hasBooking) {
                                                    Get.toNamed('/bookdetail',
                                                        arguments: {
                                                          'date': booking!
                                                              .checkDate,
                                                          'code': booking.code,
                                                        });
                                                  } else {
                                                    Get.toNamed('/app');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  hasBooking
                                                      ? Colors.blueGrey
                                                      : const Color(0xFF63B790),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        hasBooking
                                                            ? Icons.receipt_long
                                                            : Icons
                                                            .app_registration_rounded,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        hasBooking
                                                            ? "Detail"
                                                            : "Daftar",
                                                        style: const TextStyle(
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
                                : SingleChildScrollView(
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
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Artikel Terbaru",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.textColor),
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            return blogController.blogs.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: SizedBox(
                                  height: 120,
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
                                : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  blogController.blogs.length,
                                      (index) =>
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: BlogItem(
                                          data: blogController.blogs[index],
                                        ),
                                      ),
                                ),
                              ),
                            );
                          })
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

}
