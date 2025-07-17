
class AvailableRoomModel {
  final int id;
  final int number;
  final String status;
  final List<RoomImage> images;

  AvailableRoomModel({
    required this.id,
    required this.number,
    required this.status,
    required this.images,
  });

  factory AvailableRoomModel.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List;
    List<RoomImage> imagesList =
    imagesJson.map((img) => RoomImage.fromJson(img)).toList();

    return AvailableRoomModel(
      id: json['id'],
      number: json['number'],
      status: json['status'],
      images: imagesList,
    );
  }

  String get normalImage {
    try {
      return images.firstWhere((img) => img.imageType == 'normal').imagePath;
    } catch (e) {
      return images.isNotEmpty ? images.first.imagePath : '';
    }
  }
}

class RoomImage {
  final int id;
  final int roomId;
  final String imagePath;
  final String imageType;

  RoomImage({
    required this.id,
    required this.roomId,
    required this.imagePath,
    required this.imageType,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'],
      roomId: json['room_id'],
      imagePath: json['image_path'],
      imageType: json['image_type'],
    );
  }
}
