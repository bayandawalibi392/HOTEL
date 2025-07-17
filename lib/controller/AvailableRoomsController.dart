
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/linkapi.dart';
import 'dart:convert';

import '../data/AvailableRoomModel.dart';
import '../main.dart'; // اذا تستخدم Services.sharedPreference

class AvailableRoomsController extends GetxController {
  var availableRooms = <AvailableRoomModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final token = Services.sharedPreference.getString("token");

  Future<void> fetchAvailableRooms({
    required String roomTypeId,
    required String checkIn,
    required String checkOut,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      var headers = {
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse(AppLink.getAvailableRoomByDate));

      request.fields.addAll({
        'room_type_id': roomTypeId,
        'check_in': checkIn,
        'check_out': checkOut,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(resStr);

        final roomsJson = jsonResponse['available_rooms'] as List;

        availableRooms.value =
            roomsJson.map((room) => AvailableRoomModel.fromJson(room)).toList();
      } else {
        error.value = 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      error.value = 'Exception: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
