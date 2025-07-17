import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proj001/linkapi.dart';
import 'dart:convert';
import '../data/MassageRequestModel.dart';
import '../main.dart';

class MassageRequestController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var successMessage = ''.obs;
  var massageRequest = Rxn<MassageRequestModel>();
  final token = Services.sharedPreference.getString("token");


  Future<void> requestMassage({
    required String preferredTime,
    required String gender,
  }) async {
    isLoading.value = true;

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(AppLink.massageRequest));

    request.fields.addAll({
      'preferred_time': preferredTime,
      'gender': gender,
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resStr = await response.stream.bytesToString();
        final data = json.decode(resStr);
        massageRequest.value = MassageRequestModel.fromJson(data['data']);

        Get.snackbar(
          "تم الطلب",
          data['message'] ?? 'تم إرسال طلب المساج بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        final errorMsg = 'فشل الطلب: ${response.reasonPhrase}';
        Get.snackbar(
          "خطأ",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ في الاتصال",
        'حدث خطأ: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

}

