import 'package:ausy/core/models/customer.dart';
import 'package:ausy/core/services/auth_service.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final AuthService _authService = AuthService();
  var customer = Rxn<Customer>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCustomerData();
  }

  Future<void> loadCustomerData() async {
    isLoading.value = true;

    customer.value = await _authService.fetchCustomerData();

    isLoading.value = false;
  }
}
