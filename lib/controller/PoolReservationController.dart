import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/coree/constant/routes.dart';
import '../data/PoolReservationModel.dart';
import '../linkapi.dart';
import '../main.dart';

class PoolReservationController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reservation = Rxn<PoolReservationModel>();
  final token = Services.sharedPreference.getString("token");
  final TextEditingController peopleCountController = TextEditingController();
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;


  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      selectedDate.value = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> requestPoolReservation({
    required String numberOfPeople,
    required String date,
    required String time,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    reservation.value = null;

    var url = Uri.parse(AppLink.poolReversation);

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'number_of_people': numberOfPeople,
      'date': date,
      'time': time,
    });

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201) {
        final decoded = jsonDecode(responseString);
        reservation.value = PoolReservationModel.fromJson(decoded['reservation']);
        Get.snackbar("نجاح", decoded['message'],
             backgroundColor: Colors.green, colorText: Colors.white
        );
      } else {
        errorMessage.value = 'فشل الحجز: ${streamedResponse.statusCode}';
        Get.snackbar(
          "خطأ",
          errorMessage.value,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء الاتصال: $e';
      Get.snackbar(
        "خطأ",
        errorMessage.value,
        // backgroundColor: Colors.redAccent,
        // colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showCalendarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateChanged: (newDate) {
            selectedDate.value = newDate.toString().substring(0, 10);
            Get.back();
          },
        ),
      ),
    );
  }

  @override
  void onClose() {
    peopleCountController.dispose(); // تنظيف الكنترولر عند الخروج
    super.onClose();
  }
}
