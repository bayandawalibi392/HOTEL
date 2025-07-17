import 'package:get/get.dart';

import '../services/services.dart';

translateData(columnar,columnen){
  services Services =Get.find() ;

  if(Services.sharedPreference.getString("lang") == "ar"){
    return columnar;
  }else{
    return columnen;
  }
}