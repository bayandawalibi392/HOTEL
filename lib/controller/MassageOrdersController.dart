
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/MassageOrdersModel.dart';
import '../linkapi.dart';
import '../main.dart';

class MassageOrdersController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var massageRequests = <MassageOrdersModel>[].obs;
  var successMessage = ''.obs;
  final token = Services.sharedPreference.getString("token");

  Future<void> fetchMyMassageRequests({String status = "pending"}) async {
    isLoading.value = true;
    error.value = '';
    massageRequests.clear();

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      'GET',
      Uri.parse(
          AppLink.getMassageRequestsByStatus(status)),
    );

    request.headers.addAll(headers);

    print("🔍 Fetching Massage Requests with status: $status");
    print("🔐 Token: $token");

    try {
      http.StreamedResponse response = await request.send();

      final resStr = await response.stream.bytesToString();
      print("📥 Response Status: ${response.statusCode}");
      print("📦 Response Body: $resStr");

      if (response.statusCode == 200) {
        final jsonData = json.decode(resStr);
        final List<dynamic> data = jsonData['data'];

        massageRequests.value =
            data.map((item) => MassageOrdersModel.fromJson(item)).toList();
      } else {
        error.value = 'Failed with status ${response.statusCode}';
        // إضافة طباعة مفصلة للسبب
        error.value += "\nMessage: $resStr";
      }
    } catch (e) {
      error.value = 'Error: $e';
      print("🔥 Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> cancelRequest(int requestId) async {
    final url = Uri.parse(AppLink.cancelMassageRequest(requestId));
    print("Cancel URL = $url");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Get.snackbar("نجاح", res['message'] ?? "تم الإلغاء بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        fetchMyMassageRequests(status: 'pending');
      } else {
        final res = json.decode(response.body);
        Get.snackbar("خطأ", res['message'] ?? "فشل الغاء الطلب", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الإلغاء: $e");
    }
  }
  @override
  void onInit() {
    fetchMyMassageRequests();
    super.onInit();
  }
}