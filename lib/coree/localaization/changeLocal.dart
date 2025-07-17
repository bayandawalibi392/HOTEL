import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/services.dart';

class LocaleController extends GetxController{
  Locale? languge;

  services Services = Get.find();

  changeLang(String langcode){
    Locale locale = Locale(langcode);
    Services.sharedPreference.setString("lang", langcode);
    Get.updateLocale(locale);
  }
  @override
  void onInit() {
    String ? sharedPrefLang = Services.sharedPreference.getString("lang");
    if (sharedPrefLang=="ar"){
      languge = const Locale("ar");
    }else if (sharedPrefLang == "en"){
      languge = const Locale("en");
    }else{
      languge = Locale(Get.deviceLocale!.languageCode);

    }
    super.onInit();
  }
}