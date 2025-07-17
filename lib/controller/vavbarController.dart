
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../coree/constant/AppColors.dart';

class NavbarController extends GetxController {
  var navBarColor = AppColors.primary.obs;  // لون واحد للكل
  RxInt page = 0.obs;

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: page.value);
  }

  void goToPage(int index) {
    page.value = index;
    pageController.jumpToPage(index);
  }

  void onItemClick(int index) {
    page.value = index;
    pageController.jumpToPage(index);
    navBarColor.value = AppColors.secondary;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
