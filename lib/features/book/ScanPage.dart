import 'dart:convert';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ausy/features/book/controllers/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final BookController controller = Get.find();
  bool isScanned = false;


  late String code;

  @override
  void initState() {
    super.initState();

    code = Get.arguments['code'];
    print("🔥 CODE DITERIMA: $code");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Verifikasi")),
      body: Stack(
        children: [
          /// 📷 CAMERA
          MobileScanner(
            onDetect: (barcodeCapture) {
              if (isScanned) return;

              for (final barcode in barcodeCapture.barcodes) {
                final raw = barcode.rawValue;

                if (raw == null) continue;

                isScanned = true;
                _handleScan(raw);
                print("📷 QR RAW: $raw");
                break;
              }
            },
          ),


          // Container(
          //   color: Colors.black.withOpacity(0.4),
          // ),
          //
          // /// 🎯 FRAME SCAN (kotak tengah)
          // Center(
          //   child: Container(
          //     width: 250,
          //     height: 250,
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.white, width: 3),
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //   ),
          // ),

          /// ⬇️ BOTTOM INFO PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// garis kecil atas (biar aesthetic)
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🧾 TITLE
                  const Text(
                    "Scan Ausyi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 📄 DESCRIPTION
                  const Text(
                    "Arahkan kamera ke QR Code untuk verifikasi kedatangan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScan(String raw) {
    try {
      final data = jsonDecode(raw);
      print("DATA QR: $data");
      print("TOKEN QR: ${data['token']}");
      print("EXPIRED QR: ${data['expired_at']}");
      print("SIGNATURE QR: ${data['signature']}");
      print("CODE QR: $code");

      if (data['type'] != 'ausy_checkin') {
        Get.snackbar("Error", "QR tidak valid");
        isScanned = false;
        return;
      }
      if (data['token'] == null ||
          data['expired_at'] == null ||
          data['signature'] == null) {

        Get.snackbar("Error", "QR tidak valid");
        isScanned = false;
        return;
      }
      controller.verifyQR(
        token: data['token']?.toString() ?? '',
        expiredAt: data['expired_at']?.toString() ?? '',
        signature: data['signature']?.toString() ?? '',
        code: code.toString() ?? '',
      );

    } catch (e) {
      Get.snackbar("Error", "Format QR salah");
      isScanned = false;
    }
  }
}