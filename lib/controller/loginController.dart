import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/linkapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../coree/constant/routes.dart';
import '../data/userModel.dart';



class LoginControllerImp extends GetxController {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  bool isPassword = true;
  int currentTabIndex = 0;

  void changeTabIndex(int index) {
    currentTabIndex = index;
    update();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  void showPassword() {
    isPassword = !isPassword;
    update();
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      var url = Uri.parse(AppLink.login);
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'email': email.text,
        'password': password.text,
      });

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);
        var user = UserModel.fromJson(data['user']);
        String token = data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('user', json.encode(user.toJson()));

        Get.snackbar("تم تسجيل الدخول", "مرحبًا ${user.name}");
        Get.toNamed(AppRout.Navbar);
      } else {
        Get.snackbar("فشل", "البيانات غير صحيحة");
      }
    }
  }
}
