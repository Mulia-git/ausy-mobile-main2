import 'package:get_storage/get_storage.dart';

class CustomerService {
  final box = GetStorage();

  /// Simpan token FCM ke server dan local storage
  Future<void> saveToken(String? fcmToken) async {
    if (fcmToken != null) {
      try {
        // Simpan ke local storage
        box.write('fcm_token', fcmToken);
        // ignore: avoid_print
        print("FCM Token saved locally: $fcmToken");

        // Kirim token ke server
        // final response = await _dioService.dio.post(
        //     '${ApiConstants.baseUrl}${ApiConstants.firebaseEndpoint}',
        //     data: {"fcm_token": fcmToken});

        // if (response.statusCode == 200) {
        //   // ignore: avoid_print
        //   print("FCM Token successfully sent to server");
        // } else {
        //   // ignore: avoid_print
        //   print("Failed to send FCM Token: ${response.data}");
        // }
      } catch (e) {
        // ignore: avoid_print
        print("Error saving FCM Token: $e");
      }
    }
  }

  /// Ambil token yang tersimpan di local storage
  String? getToken() {
    return box.read('fcm_token');
  }
}
