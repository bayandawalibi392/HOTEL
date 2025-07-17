import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class services extends GetxService{
  late SharedPreferences sharedPreference;
  Future<services>init()async{
    sharedPreference = await SharedPreferences.getInstance();
    return this;
  }
}
initialServices()async{
  await Get.putAsync(() =>services().init());
}
