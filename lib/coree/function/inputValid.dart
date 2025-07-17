import 'package:get/get.dart';
validInput(String val,int min,int max,String type){


  if (type =="email"){
    if (!GetUtils.isEmail(val)){
      return "Email is incorrect" ;
    }
  }
  if (val.isEmpty ){
    return "can't be empty";
  }

  if (val.length < min ){
    return "can't be less than that";
  }
  if (val.length>max ){
    return "can't be larger than that";
  }
  return null;
}