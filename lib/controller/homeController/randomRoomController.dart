import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/linkapi.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/roomModel.dart';

class RandomRoomController extends GetxController {
  var isLoading = true.obs;
  var randomRoom = <RoomModel>[].obs;

  @override
  void onInit() {
    fetchRoomTypes();
    super.onInit();
  }


  Future<void> fetchRoomTypes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        var headers = {'Authorization': 'Bearer $token'};
        var response = await http.get(Uri.parse(AppLink.getRoom), headers: headers);

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          randomRoom.value = data.map((room) => RoomModel.fromJson(room)).toList();
        } else {

        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
