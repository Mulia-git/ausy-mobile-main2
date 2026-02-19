import 'dart:io';

import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/features/home/controllers/home_controller.dart';
import 'package:ausy/features/home/views/widgets/bottombar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  HomePage({super.key});

  final List<Map<String, String>> bottomMenuItems = [
    {
      "icon": "assets/icons/home.svg",
      "active_icon": "assets/icons/home.svg",
    },
    {
      "icon": "assets/icons/search.svg",
      "active_icon": "assets/icons/search.svg",
    },
    {
      "icon": "assets/icons/invoice.svg",
      "active_icon": "assets/icons/invoice.svg",
    },
    {
      "icon": "assets/icons/chat.svg",
      "active_icon": "assets/icons/chat.svg",
    },
    {
      "icon": "assets/icons/profile.svg",
      "active_icon": "assets/icons/profile.svg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Obx(() {
        return homeController.pages[homeController.selectedIndex.value];
      }),
        bottomNavigationBar: Obx(() {
          return SafeArea(
            top: false,
            child: Container(
              height: 62,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.bottomBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  bottomMenuItems.length,
                      (index) => BottomBarItem(
                    bottomMenuItems[index]["icon"]!,
                    isActive: homeController.selectedIndex.value == index,
                    activeColor: AppColor.primary,
                    onTap: () {
                      homeController.onNavItemTapped(index);
                    },
                  ),
                ),
              ),
            ),
          );
        }),

    );
  }
}
