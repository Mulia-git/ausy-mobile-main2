import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/customer.dart';
import 'package:ausy/core/services/auth_service.dart';
import 'package:ausy/core/services/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final DioService dioService = DioService();
  var isAuthenticated = false.obs;
  var isAuthenticatedUser = false.obs;
  var isLoading = false.obs; // Loading state
  var showPassword = false.obs; // Loading state
  final storage = GetStorage();
  var customer = Rxn<Customer>();
  var loadCustomer = false;
  var loadUser = false;
  var operateDrone = 'Ya'.obs;
  final AuthService _authService = AuthService();
  String get noRkmMedis => storage.read('medicalRecord') ?? '';




  AuthController() {
    // Initialize authentication status from storage
    final storedAuth = storage.read('isAuthenticated') ?? false;
    final storedAuthUser = storage.read('isAuthenticatedUser') ?? false;
    isAuthenticated.value = storedAuth;
    isAuthenticatedUser.value = storedAuthUser;

    // print(Get.currentRoute);
    // if (!["/login", "/register", "/forgot"]
    //     .contains(Get.currentRoute)) {
    //   loadCustomerData();
    // }

    // isLoading.value = false;
  }

  void onInit() {
    super.onInit();

    final storedAuth = storage.read('isAuthenticated') ?? false;
    isAuthenticated.value = storedAuth;

    if (storedAuth) {
      loadCustomerData();
    }
  }

  Future<void> loadCustomerData() async {
    isLoading.value = true;
    customer.value = await _authService.fetchCustomerData();
    isLoading.value = false;
  }


  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      const baseUrl = ApiConstants.baseUrl;
      final response = await dioService.dio.post(
        baseUrl,
        queryParameters: {
          'action': 'signin',
          'no_rkm_medis': username,
          'no_ktp': password,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.data);
        final String? state = responseData['state'];
        if (state == 'valid') {
          final String medicalRecord = responseData['no_rkm_medis'];

          isAuthenticated.value = true;
          storage.write('isAuthenticated', true);
          storage.write('medicalRecord', medicalRecord);
          Get.offNamed('/home');
        } else {
          Get.snackbar(
            'Login Gagal',
            'Tidak valid',
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Gagal menghubungi server',
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        final int? statusCode = error.response?.statusCode;
        final Map<String, dynamic> responseData = error.response?.data;
        switch (statusCode) {
          case 401:
            Get.snackbar('Error', responseData['erros']);
            break;
          case 403:
            Get.snackbar(
                'Error', 'Forbidden: You do not have access to this resource.');
            break;
          case 404:
            Get.snackbar(
                'Error', 'Not Found: The requested resource does not exist.');
            break;
          case 500:
            Get.snackbar('Error',
                'Internal Server Error: Something went wrong on the server.');
            break;
          case 422:
            Get.snackbar('Error', responseData['errors'],
                backgroundColor: Colors.red.withValues(alpha: 0.8),
                colorText: Colors.white);
            break;
          default:
            Get.snackbar('Error', 'Unhandled status code: $statusCode');
        }
      } else {
        Get.snackbar('Error', 'Unhandled DioException: ${error.type}');
      }
    } catch (error) {
      // Handle other types of exceptions
      Get.snackbar('Error', 'Unexpected error: $error');
    } finally {
      isLoading.value = false; // Hide loading
    }
  }

  Future<void> register({
    int? roleId,
    required String name,
    required String username,
    required String email,
    int? typeOfUseId,
    int? provinceId,
    int? regionId,
    required String password,
    required String passwordConfirmation,
    String? operateDrone,
  }) async {
    isLoading.value = true;
    try {
      const baseUrl = ApiConstants.baseUrl;
      final response = await dioService.dio.post(
        baseUrl,
        queryParameters: {
          'action': 'signin',
          'no_rkm_medis': username,
          'no_ktp': password,
        },
      );
      if (response.statusCode == 200) {
        Get.offNamed('/login', arguments: {
          'message':
              'Silahkan konfirmasi akunmu.\nKami telah mengirimkan link, silahkan cek whatsapp atau email anda untuk verifikasi akun'
        });
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        final int? statusCode = error.response?.statusCode;
        final Map<String, dynamic> responseData = error.response?.data;
        switch (statusCode) {
          case 401:
            Get.snackbar('Error', responseData['erros']);
            break;
          case 403:
            Get.snackbar(
                'Error', 'Forbidden: You do not have access to this resource.');
            break;
          case 404:
            Get.snackbar(
                'Error', 'Not Found: The requested resource does not exist.');
            break;
          case 500:
            Get.snackbar('Error',
                'Internal Server Error: Something went wrong on the server.');
            break;
          case 422:
            Get.snackbar('Error', responseData['errors'],
                backgroundColor: Colors.red.withValues(alpha: 0.8),
                colorText: Colors.white);
            break;
          default:
            Get.snackbar('Error', 'Unhandled status code: $statusCode');
        }
      } else {
        Get.snackbar('Error', 'Unhandled DioException: ${error.type}');
      }
    } catch (error) {

      Get.snackbar('Error', 'Unexpected error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgot({
    required String username,
  }) async {
    isLoading.value = true;
    try {
      const baseUrl = ApiConstants.baseUrl;
      final response = await dioService.dio.post(
        baseUrl,
        queryParameters: {
          'action': 'signin',
          'no_rkm_medis': username,
        },
      );

      if (response.statusCode == 200) {
        Get.offNamed('/login', arguments: {
          'message':
              'Kami telah mengiriman link reset password ke No Whatsapp anda'
        });
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        final int? statusCode = error.response?.statusCode;
        final Map<String, dynamic> responseData = error.response?.data;
        switch (statusCode) {
          case 401:
            Get.snackbar('Error', responseData['erros']);
            break;
          case 403:
            Get.snackbar(
                'Error', 'Forbidden: You do not have access to this resource.');
            break;
          case 404:
            Get.snackbar(
                'Error', 'Not Found: The requested resource does not exist.');
            break;
          case 500:
            Get.snackbar('Error',
                'Internal Server Error: Something went wrong on the server.');
            break;
          case 422:
            Get.snackbar('Error', responseData['errors'],
                backgroundColor: Colors.red.withValues(alpha: 0.8),
                colorText: Colors.white);
            break;
          default:
            Get.snackbar('Error', 'Unhandled status code: $statusCode');
        }
      } else {
        Get.snackbar('Error', 'Unhandled DioException: ${error.type}');
      }
    } catch (error) {

      Get.snackbar('Error', 'Unexpected error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authService.clearCustomerData();
    _authService.clearUserData();
    isAuthenticated.value = false;
    isAuthenticatedUser.value = false;
    storage.write('isAuthenticated', false); // Clear session
    storage.write('isAuthenticatedUser', false); // Clear session
    storage.remove('accessToken'); // Clear session
    storage.remove('accessTokenUser'); // Clear session
    Get.offAllNamed('/login');
  }
}
