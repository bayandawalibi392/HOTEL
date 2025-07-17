class RoomModel {
  final int id;
  final int number;
  final String status;
  final String image;
  final String price;
  final String? description;

  RoomModel({
    required this.id,
    required this.number,
    required this.status,
    required this.image,
    required this.price,
    this.description,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List;
    final normalImage = images.firstWhere(
          (img) => img['image_type'] == 'normal',
      orElse: () => null,
    );

    return RoomModel(
      id: json['id'],
      number: json['number'],
      status: json['status'] ,
      image: normalImage != null ? normalImage['image_path'] : '',
      price: json['room_type']['price'],
      description: json['room_type']['description_ar'],
    );
  }
}
