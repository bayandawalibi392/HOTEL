import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proj001/linkapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../coree/constant/routes.dart';
import '../data/userModel.dart';


class SignUpController extends GetxController {
  final signUpFormKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
  final phone = TextEditingController();

  bool isPasswordHidden = true;

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  Future<void> signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      var url = Uri.parse(AppLink.signUp); // غيّر localhost إلى IP جهاز السيرفر إذا لزم الأمر

      var request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'password_confirmation': password.text,
        'phone': phone.text,
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);
        UserModel user = UserModel.fromJson(data['user']);
        String token = data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('user', json.encode(user.toJson()));

        Get.snackbar("تم إنشاء الحساب", "مرحبًا ${user.name}");
        Get.toNamed(AppRout.HomeScreen); // التنقل إلى الشاشة التالية إذا أردت
      } else {
        var errorBody = await response.stream.bytesToString();
        print("❌ Error response: $errorBody");
        Get.snackbar("خطأ", "فشل إنشاء الحساب");
      }
    }
  }
}
