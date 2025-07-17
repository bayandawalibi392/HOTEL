
import 'package:get/get.dart';

class RoomImage {
  final String imagePath;
  final String imageType;

  RoomImage({required this.imagePath, required this.imageType});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      imagePath: json['image_path'],
      imageType: json['image_type'],
    );
  }
}

class RoomDetailsModel {
  final int id;
  final int number;
  final String status;
  final String price;
  final String descriptionAr;
  final String? descriptionEn;
  final List<RoomImage> images;

  RoomDetailsModel({
    required this.id,
    required this.number,
    required this.status,
    required this.price,
    required this.images,
    required this.descriptionAr,
    this.descriptionEn,
  });

  factory RoomDetailsModel.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List<dynamic>;
    return RoomDetailsModel(
      id: json['id'],
      number: json['number'],
      status: json['status'],
      price: json['room_type']['price'],
      // description: json['room_type']['description_ar'],
      descriptionAr: json['room_type']['description_ar'],
      descriptionEn: json['room_type']['description_en'],
      images: imageList.map((e) => RoomImage.fromJson(e)).toList(),
    );
  }
  String get description => Get.locale?.languageCode == 'en'
      ? (descriptionEn ?? descriptionAr)
      : descriptionAr;
}

