
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/linkapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/roomTypeModel.dart';


class RoomTypeController extends GetxController {
  var roomTypes = <RoomTypeModel>[].obs;
  var isLoading = false.obs;
  final ScrollController tabScrollController = ScrollController();
  @override
  void onInit() {
    fetchRoomTypes();
    super.onInit();
  }

  Future<void> fetchRoomTypes() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var request = http.Request('GET', Uri.parse(AppLink.roomTypes));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final jsonString = await response.stream.bytesToString();
        final List<dynamic> jsonData = json.decode(jsonString);
        final List<dynamic> roomList = jsonData.first;

        roomTypes.assignAll(roomList.map((item) => RoomTypeModel.fromJson(item)).toList());
      } else {
        final errorBody = await response.stream.bytesToString();
        debugPrint("API Error Body: $errorBody");
        Get.snackbar("خطأ ${response.statusCode}", "فشل في التحميل، راجع الكونسول");
      }
    }  catch (e) {
      debugPrint("Exception during API call: $e");
      Get.snackbar("خطأ في الاتصال", "حدث استثناء أثناء الاتصال، راجع الكونسول");
    } finally {
      isLoading.value = false;
    }
  }

}
