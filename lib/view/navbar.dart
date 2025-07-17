
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // تأكد من استيراد الحزمة
import 'package:proj001/view/MassageScreen.dart';
import 'package:proj001/view/poolScreen.dart';
import 'package:proj001/view/restaurantScreen.dart';
import 'package:proj001/view/weddingHallScreen.dart';

import '../controller/vavbarController.dart';
import '../coree/constant/AppColors.dart';
import 'ProfileScreen.dart';
import 'homeScreen.dart';
class Navbar extends GetView<NavbarController> {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController controller = Get.find<NavbarController>();
    final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

    return Scaffold(
      bottomNavigationBar: Obx(() => CurvedNavigationBar(
        key: bottomNavigationKey,
        color: controller.navBarColor.value,
        index: controller.page.value,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        onTap: (index) {
          controller.onItemClick(index);
        },
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.restaurant, size: 30, color: Colors.white),
          Icon(Icons.spa, size: 30, color: Colors.white),
          Icon(Icons.pool, size: 30, color: Colors.white),
          Icon(Icons.celebration, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
      )),
      body: WillPopScope(
        onWillPop: () {
          Get.defaultDialog(
            title: "تنبيه",
            titleStyle: const TextStyle(fontWeight: FontWeight.bold),
            middleText: "هل تريد الخروج من التطبيق؟",
            onCancel: () {},
            cancelTextColor: AppColors.primary,
            confirmTextColor: Colors.white,
            buttonColor: AppColors.primary,
            onConfirm: () {
              exit(0);
            },
          );
          return Future.value(false);
        },
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeScreen(),
            RestaurantScreen(),
             MassageScreen(),
             PoolScreen(),
            const WeddingHallScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
