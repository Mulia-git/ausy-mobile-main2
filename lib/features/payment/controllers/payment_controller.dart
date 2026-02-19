import 'package:ausy/core/models/payment.dart';
import 'package:ausy/core/services/payment_service.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  // List dokter dari API
  var payments = <Payment>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;

  final PaymentService _paymentService = PaymentService();

  // Ambil data dokter berdasarkan tanggal
 Future<void> loadPayments() async {
  isLoading.value = true;

  final fetched = await _paymentService.fetchPayments();

  // Urutkan berdasarkan nama (A-Z)
  fetched.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  payments.value = fetched;

  isLoading.value = false;
}

  // Ganti teks pencarian
  void changeQuery(String query) {
    searchQuery.value = query;
  }

  // Daftar dokter hasil filter
  List<Payment> get filteredPayments{
    List<Payment> list = payments;
    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((payment) {
        final query = searchQuery.value.toLowerCase();
        return payment.name.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}
