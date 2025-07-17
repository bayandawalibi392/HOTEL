import 'package:get/get.dart';

class RoomTypeModel {
  final int id;
  final String typeNameAr;
  final String typeNameEn;
  final String descriptionAr;
  final String? descriptionEn;
  final String price;

  RoomTypeModel({
    required this.id,
    required this.typeNameAr,
    required this.typeNameEn,
    required this.descriptionAr,
     this.descriptionEn,
    required this.price,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      id: json['id'],
      typeNameAr: json['type_name_ar'],
      typeNameEn: json['type_name_en'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      price: json['price'],
    );
  }

  String get typeName => Get.locale?.languageCode == 'en' ? typeNameEn : typeNameAr;
  String get description => Get.locale?.languageCode == 'en'
      ? (descriptionEn ?? descriptionAr)
      : descriptionAr;
}
