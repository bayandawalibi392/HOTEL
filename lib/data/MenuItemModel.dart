import 'package:get/get.dart';

class MenuItemModel {
  final int id;
  final String arName;
  final String enName;
  final String arDescription;
  final String enDescription;
  final String photo;
  final String type;
  final String price;

  MenuItemModel({
    required this.id,
    required this.arName,
    required this.enName,
    required this.arDescription,
    required this.enDescription,
    required this.photo,
    required this.type,
    required this.price,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      arName: json['ar_name'],
      enName: json['en_name'],
      arDescription: json['ar_description'],
      enDescription: json['en_description'],
      photo: json['photo'],
      type: json['type'],
      price: json['price'].toString(),
    );
  }
  String get Name => Get.locale?.languageCode == 'en' ? enName : arName;
  String get description => Get.locale?.languageCode == 'en'
      ? (enDescription ?? arDescription)
      : arDescription;
}
