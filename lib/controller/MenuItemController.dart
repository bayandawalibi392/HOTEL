

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj001/linkapi.dart';
import '../data/MenuItemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class MenuItemController extends GetxController {
  var menuItems = <MenuItemModel>[].obs;
  var isLoading = false.obs;
  final token = Services.sharedPreference.getString("token");
  List<String> types = ["All", "Appetizers", "Main_Course", "Desserts", "Drinks"];
  var selectedType = "All".obs;
  var selectedItem = Rxn<MenuItemModel>();
  var quantity = 1.obs;
  var cart = <Map<String, dynamic>>[].obs;
  var orderType = "room".obs;
  var numberController = TextEditingController();
  var durationController = TextEditingController();
  var peopleController = TextEditingController();

  @override
  void onInit() {
    fetchAllItems();
    super.onInit();
  }

  void addToCart(MenuItemModel item, int qty) {
    int index = cart.indexWhere((element) => element["item"].id == item.id);
    if (index >= 0) {
      cart[index]["quantity"] += qty;
      cart.refresh();
    } else {
      cart.add({"item": item, "quantity": qty});
    }
  }


  void fetchAllItems() async {
    isLoading.value = true;
    var url = Uri.parse(AppLink.getMenuItem);
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      menuItems.value = data.map((e) => MenuItemModel.fromJson(e)).toList();
    } else {
      print("Error: ${response.body}");
    }
    isLoading.value = false;
  }


  void fetchItemsByType(String type) async {
    selectedType.value = type;
    if (type == "All") {
      fetchAllItems();
      return;
    }
    isLoading.value = true;
    var url = Uri.parse(AppLink.getMenuItemByType(type));
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      menuItems.value = data.map((e) => MenuItemModel.fromJson(e)).toList();
    } else {
      print("Error: ${response.body}");
    }
    isLoading.value = false;
  }


  void setSelectedItem(MenuItemModel item) {
    selectedItem.value = item;
    quantity.value = 1;
  }

  void increaseQuantity() => quantity.value++;
  void decreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
  }

  Future<void> submitOrder({
    required String orderType,
    required int? tableOrRoomNumber,
    int? bookedDuration,
    int? numberOfPeople,
  }) async {
    if (tableOrRoomNumber == null || tableOrRoomNumber <= 0) {
      Get.snackbar("خطأ", "يرجى إدخال رقم الغرفة أو الطاولة صحيح",);
      return;
    }
    var url = Uri.parse(AppLink.requestOrder);

    var menuItemsPayload = cart.map((e) {
      return {
        "id": e["item"].id,
        "quantity": e["quantity"],
      };
    }).toList();

    var body = {
      "order_type": orderType,
      "preferred_time": DateTime.now().toIso8601String(),
      "menu_items": menuItemsPayload,
      "table_or_room_number": tableOrRoomNumber,
      "booked_duration": bookedDuration,
      if (orderType == "table") "number_of_people": numberOfPeople,
    };
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.post(url, body: json.encode(body), headers: headers);
    if (response.statusCode == 201) {
      final res = json.decode(response.body);
      Get.snackbar("Success", res['message'] ?? "تم إنشاء الطلب بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
      cart.clear();
      numberController.clear();
      durationController.clear();
      peopleController.clear();
    } else {
      Get.snackbar("Error", "حدث خطأ أثناء إرسال الطلب", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
