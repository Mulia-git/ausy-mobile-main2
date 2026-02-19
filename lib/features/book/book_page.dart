import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:ausy/core/helpers/date_helper.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/book/controllers/book_controller.dart';
import 'package:ausy/features/schedule/controllers/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookPage> {
  int selectedDateIndex = 0;
  String? selectedTimeIndex;
  final RxString selectedPaymentCode = "-".obs;
  final RxString selectedPaymentName = "Belum Dipilih".obs;
  final RxString selectedPolyclinicCode = "-".obs;
  final RxString selectedPolyclinicName = "Belum Dipilih".obs;
  final RxString selectedPolyclinicStart = "".obs;
  final RxString selectedPolyclinicFinish = "".obs;

  late List<DateTime> next7Days;
  final ScheduleController scheduleController =
      Get.put(ScheduleController(), permanent: true);
  final BookController bookController =
      Get.put(BookController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    next7Days = List.generate(
      7,
          (index) => DateTime.now().add(Duration(days: index + 1)),
    );

    final doctor = bookController.selectedDoctor.value;


    if (doctor != null) {
      final pickedDate = DateTime.parse(bookController.date.value);

      selectedDateIndex = next7Days.indexWhere((d) =>
      d.year == pickedDate.year &&
          d.month == pickedDate.month &&
          d.day == pickedDate.day);

      if (selectedDateIndex == -1) selectedDateIndex = 0;


      scheduleController.date.value = bookController.date.value;
      selectedPolyclinicCode.value = doctor.polyCode;
      selectedPolyclinicName.value = doctor.polyclinic;


      bookController.poly.value = doctor.polyCode;
      bookController.selectedDoctorId.value = doctor.code;
    } else {
      scheduleController.date.value =
          DateFormat('yyyy-MM-dd').format(next7Days[0]);
      bookController.date.value = scheduleController.date.value;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await bookController.loadDoctors();

      Future.delayed(const Duration(milliseconds: 300), () {
        final selectedId = bookController.selectedDoctorId.value;
        final index =
        bookController.doctors.indexWhere((d) => d.code == selectedId);

        if (index != -1) {
          _scrollController.animateTo(
            index * 75,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }


  bool _validate() {
    bool isValidate = true;
    if (selectedPaymentCode.value == "") {
      isValidate = false;
    }
    if (selectedPolyclinicCode.value == "") {
      isValidate = false;
    }
    if (bookController.selectedDoctorId.value == "") {
      isValidate = false;
    }
    return isValidate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: "Pendaftaran",
          backgroundColor: Colors.white,
        ),
        body: _buildBody(context));
  }

  Obx _buildBody(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Selector
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cara Bayar',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Doctor Info
                      GestureDetector(
                        onTap: () async {
                          var select = await Get.toNamed('/payment');
                          if (select != null) {
                            selectedPaymentCode.value = select.code;
                            selectedPaymentName.value = select.name;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              // CircleAvatar(
                              //   radius: 24,
                              //   backgroundColor: AppColor.primary,
                              //   child: Text(
                              //     selectedPaymentName.value.isNotEmpty
                              //         ? selectedPaymentName.value[0]
                              //             .toUpperCase()
                              //         : '',
                              //     style: const TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 20,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedPaymentName.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedPaymentCode.value,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.arrow_drop_down_circle,
                                color: AppColor.primary,
                                size: 32,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date Selector
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tanggal',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: next7Days.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final date = next7Days[index];
                            final hari = hariIndo(date); // Sen, Sel, etc
                            final tanggal =
                                DateFormat('dd').format(date); // 25, 26, etc
                            final isSelected = selectedDateIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedDateIndex = index);
                                scheduleController.date.value =
                                    DateFormat('yyyy-MM-dd').format(date);
                                selectedPolyclinicCode.value = "-";
                                selectedPolyclinicName.value = "Belum Dipilih";
                                selectedPolyclinicStart.value = "";
                                selectedPolyclinicFinish.value = "";
                                bookController.selectedDoctorId.value = "";
                                bookController.date.value =
                                    scheduleController.date.value;
                                bookController.poly.value = "";
                                bookController.loadDoctors();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColor.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      hari,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tanggal,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Date Selector
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Polikinik',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Doctor Info
                      GestureDetector(
                        onTap: bookController.fromSchedule.value
                            ? null
                            : () async {
                          var select = await Get.toNamed('/schedule');
                          if (select != null) {
                            selectedPolyclinicCode.value = select.code;
                            selectedPolyclinicName.value = select.name;
                            bookController.setPoly(select.code);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: bookController.fromSchedule.value
                                ? Colors.grey.shade100
                                : Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                          ),

                          child: Row(
                            children: [
                              // CircleAvatar(
                              //   radius: 24,
                              //   backgroundColor: AppColor.primary,
                              //   child: Text(
                              //     selectedPolyclinicName.value.isNotEmpty
                              //         ? selectedPolyclinicName.value[0]
                              //             .toUpperCase()
                              //         : '',
                              //     style: const TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 20,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedPolyclinicName.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    // Text(
                                    //   "${selectedPolyclinicStart.value} - ${selectedPolyclinicFinish.value}",
                                    //   style:
                                    //       const TextStyle(color: Colors.grey),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.arrow_drop_down_circle,
                                color: AppColor.primary,
                                size: 32,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Date Selector
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dokter',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // List of Doctors
                      bookController.isLoadingSchedule.value
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
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Obx(() {
                        if (bookController.isLoadingSchedule.value) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }

                        if (bookController.doctors.isEmpty) {
                          return _buildEmptyState(context);
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: bookController.doctors.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final doctor = bookController.doctors[index];

                            return Obx(() {
                              final selected =
                                  bookController.selectedDoctorId.value == doctor.code;

                              return GestureDetector(
                                onTap: () => bookController.selectedDoctorId.value = doctor.code,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: selected ? AppColor.primary : Colors.white,
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: doctor.code,
                                        groupValue: bookController.selectedDoctorId.value,
                                        onChanged: (v) =>
                                        bookController.selectedDoctorId.value = v ?? "",
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doctor.name,
                                              style: TextStyle(
                                                color: selected ? Colors.white : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Jam ${doctor.start} - ${doctor.end}",
                                              style: TextStyle(
                                                color: selected ? Colors.white70 : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      }),


                    ],
                  ),
                ),
              ),
            ),

            // Book Appointment Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validate() && bookController.isLoading.isFalse
                      ? () async {
                          if (selectedPaymentCode.value == "BPJ") {
                            if (Platform.isAndroid) {
                              launchUrl(Uri.parse(
                                  'https://play.google.com/store/apps/details?id=app.bpjs.mobile'));
                            } else if (Platform.isIOS) {
                              launchUrl(Uri.parse(
                                  'https://apps.apple.com/id/app/mobile-jkn/id1237601115'));
                            }
                          } else {
                            await bookController.register(
                              date: scheduleController.date.value,
                              polyclinic: selectedPolyclinicCode.value,
                              doctor: bookController.selectedDoctorId.value,
                              insurance: selectedPaymentCode.value,
                            );

                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _validate()
                        ? const Color(0xFF63B790)
                        : AppColor.appBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 16,
                      color: _validate() ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
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
