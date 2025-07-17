import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/routes.dart';
import '../services/services.dart';

class MidleWare extends GetMiddleware{

  @override
  int? get priority => 1;

  services Services =Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (Services.sharedPreference.getString("step") == "2") {
      // return RouteSettings(name: AppRout.homeScreen);
    }
    if (Services.sharedPreference.getString("step") == "1") {
      return const RouteSettings(name: AppRout.login);
    }
  }
  }
