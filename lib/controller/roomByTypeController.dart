import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/roomModel.dart';
import '../linkapi.dart';
import '../main.dart';

class RoomByTypeController extends GetxController {
  var isLoading = true.obs;
  var roomTypes = <RoomModel>[].obs;
  final token = Services.sharedPreference.getString("token");

  Future<void> fetchRoomsByType(int roomTypeId) async {
    try {
      isLoading.value = true;
      if (token != null) {
        var headers = {'Authorization': 'Bearer $token'};
        var response = await http.get(
          Uri.parse(AppLink.getRoomsByType(roomTypeId)),
          headers: headers,
        );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          List<dynamic> data = jsonResponse['rooms'];

          roomTypes.value =
              data.map((room) => RoomModel.fromJson(room)).toList();
        } else {
          print('فشل في تحميل الغرف: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب الغرف: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

