import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  final GetStorage storage = GetStorage();
  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated = storage.read('isAuthenticated') ?? false;
    if (!isAuthenticated) {
      // Redirect to login if the user is not authenticated
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
