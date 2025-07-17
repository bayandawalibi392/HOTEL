import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/linkapi.dart';
import 'dart:convert';

import '../data/orderFoodModel.dart';
import '../main.dart';


class orderFoodController extends GetxController {
  var isLoading = false.obs;
  var orders = <Order>[].obs;
  var errorMessage = ''.obs;
  final token = Services.sharedPreference.getString("token");
  @override
  void onInit() {
    fetchUserOrders();
    super.onInit();
  }

  Future<void> fetchUserOrders() async {
    try {
      isLoading(true);
      errorMessage('');

      var headers = {
        'Authorization':'Bearer $token',
        'Accept': 'application/json',
      };

      var request = http.Request(
          'GET',
          Uri.parse(AppLink.getOrderFood)
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        var orderResponse = OrderListResponse.fromJson(jsonResponse);
        orders.assignAll(orderResponse.orders);
      } else {
        errorMessage('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error fetching orders: $e');
    } finally {
      isLoading(false);
    }
  }
  Future<void> cancelOrder(int orderId) async {
    final url = Uri.parse(AppLink.cancelOrder(orderId));

    isLoading.value = true;

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Get.snackbar("تم الإلغاء", res['message'] ?? "تم إلغاء الطلب بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        // يمكنك إعادة تحميل الطلبات هنا لو أردت
      } else {
        final res = json.decode(response.body);
        Get.snackbar("خطأ", res['message'] ?? "فشل في إلغاء الطلب", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "حدث خطأ أثناء الإلغاء: $e");
    }
  }
  void refreshOrders() async {
    await fetchUserOrders();
  }
}