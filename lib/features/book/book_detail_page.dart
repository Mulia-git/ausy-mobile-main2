import 'dart:async';
import 'dart:convert';

import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/book/controllers/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'ScanPage.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final BookController bookController =
      Get.put(BookController(), permanent: true);
  final String date = Get.arguments['date'];
  final String code = Get.arguments['code'];
  final TextEditingController baseUrlController = TextEditingController();
  Map<String, String>? info;
  final GetStorage storage = GetStorage();
  Timer? timer;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookController.booking.value == null) {
        bookController.loadBookingDetail(date, code);
      }
    });
    if (Get.arguments['fromRegister'] == true) {
      Future.delayed(const Duration(milliseconds: 400), () {
        bookController.showSuccessDialog("Pendaftaran berhasil");
      });
    }


    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      bookController.loadBookingDetail(date, code, silent: true);
    });
    if (Get.arguments['fromCheckin'] == true) {
      showSuccessDialog("Anda sudah check-in");
    }
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _infoRow(String label, String value) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text("$label:")),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "No Antrian : $code",
        backgroundColor: const Color(0xFF63B790),
        textColor: Colors.white,
      ),
      body: Obx(() {
        final booking = bookController.booking.value;

        if (booking == null) {
          return const Center(child: CircularProgressIndicator());
        }

        /// 🔥 mapping data
        info = {
          "Nomor Rekam Medis": storage.read('medicalRecord') ?? '',
          "Tanggal daftar": booking.registerDate,
          "Tanggal periksa": booking.checkDate,
          "Status validasi": booking.status,
          "Klinik": booking.polyclinic,
          "Dokter": booking.doctor,
          "Nomor antrian": booking.code,
          "Cara bayar": booking.insurance,
        };

        return SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [

                  /// 🔥 INFO DATA (INI YANG SEBELUMNYA HILANG)
                  ...info!.entries
                      .map((e) => _infoRow(e.key, e.value))
                      .toList(),

                  const SizedBox(height: 20),

                  /// STATUS / QR
                  if (booking.status == "Terdaftar")
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.verified,
                              color: Colors.green, size: 50),
                          SizedBox(height: 10),
                          Text(
                            "Sudah Check-in",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),



                  const SizedBox(height: 24),

                  /// BUTTON CANCEL
                  if (_canCancel(booking.checkDate) && booking.status != "Terdaftar")
                    _buildCancelButton(context)
                  else if (booking.status == "Terdaftar")
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Anda sudah check-in",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Registrasi tidak dapat dibatalkan karena tanggal pemeriksaan telah lewat.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),

                  /// NOTE
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF2F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Terima kasih atas kepercayaan Anda.\n"
                          "Bawalah kartu berobat Anda dan datang 1 jam sebelumnya.\n\n"
                          "Jika memilih cara bayar UMUM, lakukan pembayaran di kasir terlebih dahulu sebelum ke Poliklinik tujuan Anda.\n\n"
                          "Jika memilih cara bayar BPJS, bawalah surat rujukan atau surat kontrol asli dan tunjukkan pada petugas di lobby resepsionis.",
                      style: TextStyle(fontSize: 12, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
   return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.cancel, color: Colors.white),
              label: const Text(
                "Batal Registrasi",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showCancelDialog(context),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text(
                "Scan QR",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
                onPressed: () async {
                  timer?.cancel();

                  final result = await Get.to(
                        () => const ScanPage(),
                    arguments: {
                      "code": code,
                    },
                  );

                  if (result == 'success') {
                    bookController.loadBookingDetail(date, code);
                  }


                  timer = Timer.periodic(const Duration(seconds: 3), (_) {
                    bookController.loadBookingDetail(date, code, silent: true);
                  });
                },
            ),
          ),
        ),
      ],
    );
  }
  void _showCancelDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Batalkan Registrasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Silakan isi alasan pembatalan:",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),


            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Contoh: Ada keperluan mendadak",
                contentPadding: const EdgeInsets.all(12),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
          ],
        ),

        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        actions: [

          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Batal",
              style: TextStyle(
                color: Colors.black, // biar jelas
                fontWeight: FontWeight.w600,
              ),
            ),
          ),


          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white, // teks putih otomatis
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {

                _showWarningDialog("Alasan wajib diisi");
                return;
              }

              Get.back();
              bookController.cancelBooking(code, reasonController.text.trim());
            },
            child: const Text(
              "Ya, Batalkan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
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
  void showSuccessDialog(String message) {
    Future.delayed(const Duration(milliseconds: 200), () {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text("Berhasil"),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Get.back(); // tutup dialog
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    });
  }
  bool _canCancel(String date) {
    final bookingDate = DateTime.parse(date);
    final today = DateTime.now();

    final todayOnly = DateTime(today.year, today.month, today.day);

    return bookingDate.isAfter(todayOnly) ||
        bookingDate.isAtSameMomentAs(todayOnly);
  }

}
