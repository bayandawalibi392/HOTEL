import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/viewOrderModel.dart';
import '../linkapi.dart';
import '../main.dart';

class ViewOrderController extends GetxController {
  RxList<ViewOrderModel> bookings = <ViewOrderModel>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxString currentStatus = 'pending'.obs;
  final token = Services.sharedPreference.getString("token");

  @override
  void onInit() {
    super.onInit();
    fetchBookingsByStatus('pending');
  }

  Future<void> fetchBookingsByStatus(String status) async {
    isLoading.value = true;
    error.value = '';
    bookings.clear();

    try {
      final url = Uri.parse(AppLink.getMyBookingsByStatus(status));
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'];
        bookings.value = list.map((e) => ViewOrderModel.fromJson(e)).toList();
      } else {
        error.value = 'فشل في تحميل البيانات';
      }
    } catch (e) {
      error.value = 'حدث خطأ: $e';
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> cancelBooking(int bookingId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await http.post(
        Uri.parse(AppLink.cancelBooking(bookingId)),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Get.snackbar('تم الإلغاء', res['message'], backgroundColor: Colors.green, colorText: Colors.white);

        // إعادة تحميل الحجوزات الحالية
        fetchBookingsByStatus(currentStatus.value);
      } else {
        Get.snackbar('خطأ', 'فشل في الإلغاء: ${response.reasonPhrase}', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('استثناء', 'حدث خطأ أثناء الإلغاء: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

}
