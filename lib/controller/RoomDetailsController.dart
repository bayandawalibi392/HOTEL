
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/coree/constant/routes.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../coree/constant/AppColors.dart';
import '../data/RoomDetailsModel.dart';
import '../linkapi.dart';
import '../main.dart';

class RoomDetailsController extends GetxController {
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var isLoading = false.obs;
  var room = Rxn<RoomDetailsModel>();
  final token = Services.sharedPreference.getString("token");

  Future<void> fetchRoomDetails(int roomId) async {
    try {
      isLoading(true);
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(AppLink.getRoomDetails(roomId)),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        room.value = RoomDetailsModel.fromJson(data);
      } else {
        Get.snackbar("خطأ", "فشل في تحميل البيانات: ${response.reasonPhrase}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل البيانات");
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickDate({
    required bool isStart,
    required BuildContext context,

  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.tablesBackground,
              onSurface: AppColors.secondary,
            ),
            dialogBackgroundColor: AppColors.tablesBackground,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }

  Future<void> bookRoom({required int roomId}) async {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar("خطأ", "يرجى اختيار تاريخ الدخول والخروج");
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(AppLink.bookRoom);
    final headers = {
      'Authorization': 'Bearer $token', // غيّر التوكن الحقيقي هنا
      'Accept': 'application/json',
    };

    final request = http.MultipartRequest('POST', url)
      ..fields['room_id'] = roomId.toString()
      ..fields['check_in'] = startDate.value!.toIso8601String().split('T')[0]
      ..fields['check_out'] = endDate.value!.toIso8601String().split('T')[0]
      ..headers.addAll(headers);

    try {
      final response = await request.send();
      final result = await response.stream.bytesToString();
      final data = json.decode(result);

      if (response.statusCode == 201) {
        Get.snackbar("نجاح", data['message'] ?? 'تم الحجز بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
        Get.toNamed(AppRout.RoomTypeScreen);
      } else {
        Get.snackbar("خطأ", data['message'] ?? 'فشل في تنفيذ الحجز', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخادم");
    } finally {
      isLoading.value = false;
    }
  }
}
