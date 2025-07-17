import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'appRoute.dart';
import 'controller/MenuItemController.dart';
import 'controller/vavbarController.dart';
import 'coree/localaization/changeLocal.dart';
import 'coree/localaization/translation.dart';
import 'coree/services/services.dart';
services Services =Get.find();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  Get.put(NavbarController()
      // , permanent: true
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      locale: controller.languge,
      // themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // darkTheme: Themes.customDarkTheme,
      // theme: Themes.customLightTheme,
      debugShowCheckedModeBanner: false,
      // initialBinding: InitialBindings(),
      getPages: routes,
    );
  }
}
